
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers } from './__generated__/graphql';
import { readFileSync } from 'fs';
import movieResolver from './resolvers/query/movie-resolver';
import searchResolver from './resolvers/query/search-resolver';
import signUp from './resolvers/mutation/signUp';
import prisma from './prisma';
import addToWatchList from './resolvers/mutation/addToWatchlist';
import isOnWatchlistResolver from './resolvers/query/isOnWatchListResolver';
import WatchListDataSource from './dataloaders/watchListDataloader';
import { GraphQLError } from 'graphql';
import removeFromWatchList from './resolvers/mutation/removeFromWatchList';
import watchList from './resolvers/query/watchList';
import { GraphQLContext } from './graphql/GraphQLContext';
import importGenres from './tmbd/import-genres';

const boot = async () => {
  await importGenres();

  const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

  const resolvers: Resolvers = {
    Query: {
      movies: movieResolver,
      search: searchResolver,
      watchList: (_, __, context) => watchList(context)
    },
    Mutation: {
      signUp: (_, args) => signUp(args),
      addToWatchList,
      removeFromWatchList
    },
    Movie: {
      metadata: () => ({ id: 1, runtime: 120 }),
      isOnWatchList: isOnWatchlistResolver,
    },
  };

  const app = express();
  const httpServer = http.createServer(app);

  const server = new ApolloServer<GraphQLContext>({
    typeDefs,
    resolvers,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
  });

  await server.start();

  app.use(
    '/graphql',
    cors<cors.CorsRequest>(),
    express.json(),
    expressMiddleware(server, {
      context: async ({ req }) => {
        let context: GraphQLContext = {
          dataSources: {
            watchList: new WatchListDataSource(prisma)
          }
        }
        const sessionId = req.headers.authorization;
        if (sessionId) {
          const user = await prisma.device.findUnique({ where: { sessionId }, include: { user: true } });
          if (!user) {
            throw new GraphQLError('Unauthorized', { extensions: { code: 'UNAUTHORIZED' } });
          }
          context.user = user.user;
        }
        return context
      }
    }),
  );

  app.get('/test', (_, res) => {
    res.send('Hello from Express!');
  })

  const port = process.env.PORT || 4000;

  await new Promise<void>((resolve) => httpServer.listen({ port }, resolve));
  console.log(`📡 listening on port ${port}`);

}

export default boot;
