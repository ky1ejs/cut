
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers } from './__generated__/graphql';
import { readFileSync } from 'fs';
import movieResolver from './resolvers/query/movie-resolver';
import genreResolver from './resolvers/query/genre-resolver';
import searchResolver from './resolvers/query/search-resolver';
import signUp from './resolvers/mutation/signUp';

const boot = async () => {
  const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

  const resolvers: Resolvers = {
    Query: {
      movies: movieResolver,
      search: (_, args) => { return searchResolver(args) }
    },
    Mutation: {
      signUp: (_, args) => { return signUp(args) }
    },
    Movie: {
      metadata: () => ({ id: 1, runtime: 120 })
    },
    Genre: {
      metadata: genreResolver
    }
  };


  interface MyContext {
    token?: string;
  }

  const app = express();
  const httpServer = http.createServer(app);

  const server = new ApolloServer<MyContext>({
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
      context: async ({ req }) => ({ token: req.headers.token }),
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
