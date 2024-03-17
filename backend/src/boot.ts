
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers, ExtendedMovie } from './__generated__/graphql';
import { readFileSync } from 'fs';
import moviesResolver from './resolvers/query/movie-resolver';
import searchResolver from './resolvers/query/search-resolver';
import signUp from './resolvers/mutation/signUp';
import prisma from './prisma';
import addToWatchList from './resolvers/mutation/addToWatchlist';
import isOnWatchlistResolver from './resolvers/query/isOnWatchListResolver';
import WatchListDataLoader from './dataloaders/watchListDataLoader';
import { GraphQLError } from 'graphql';
import removeFromWatchList from './resolvers/mutation/removeFromWatchList';
import watchList from './resolvers/query/watchList';
import { GraphQLContext } from './graphql/GraphQLContext';
import importGenres from './tmbd/import-genres';
import movieResolver from './resolvers/query/movie';
import completeAccount from './resolvers/mutation/completeAccount';
import follow from './resolvers/mutation/follow';
import unfollow from './resolvers/mutation/unfollow';
import initiateEmailVerification from './resolvers/query/initiateEmailVerification';
import isUsernameAvailable from './resolvers/query/isUsernameAvailable';
import getAccount from './resolvers/query/getAccount';
import AnnonymousWatchListDataLoader from './dataloaders/annonymousWatchListDataLoader';

const boot = async () => {
  await importGenres();

  const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

  const resolvers: Resolvers = {
    Query: {
      account: getAccount,
      movies: moviesResolver,
      search: searchResolver,
      watchList: (_, __, context) => watchList(context),
      movie: movieResolver,
      initiateEmailVerification,
      isUsernameAvailable
    },
    Mutation: {
      signUp: (_, args) => signUp(args),
      addToWatchList,
      removeFromWatchList,
      completeAccount,
      follow,
      unfollow
    },
    MovieInterface: {
      __resolveType: (movie) => {
        if (movie.__typename === 'ExtendedMovie') {
          return 'ExtendedMovie';
        }
        return 'Movie';
      },
      isOnWatchList: isOnWatchlistResolver
    },
    ExtendedMovie: {
      isOnWatchList: isOnWatchlistResolver
    },
    Movie: {
      isOnWatchList: isOnWatchlistResolver
    },
    AccountUnion: {
      __resolveType: (parent) => {
        return parent.__typename!
      }
    },
    CompleteAccount: {
      watchList: (_, __, context) => watchList(context)
    },
    IncompleteAccount: {
      watchList: (_, __, context) => watchList(context)
    }
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
            watchList: new WatchListDataLoader(prisma),
            annonymousWatchList: new AnnonymousWatchListDataLoader(prisma)
          }
        }
        const sessionId = req.headers.authorization;
        if (sessionId) {
          const userDevicePromise = prisma.device.findUnique({ where: { sessionId }, include: { user: true } });
          const annonUserDevicePromise = prisma.annonymousDevice.findUnique({ where: { sessionId }, include: { user: true } })
          const [userDevice, annonUserDevice] = await Promise.all([userDevicePromise, annonUserDevicePromise])
          if (userDevice) {
            context.userDevice = userDevice;
          }
          if (annonUserDevice) {
            context.annonymousUserDevice = annonUserDevice;
          }
          if (context.userDevice === undefined && context.annonymousUserDevice === undefined) {
            throw new GraphQLError('Unauthorized', { extensions: { code: 'UNAUTHORIZED' } });
          }
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
