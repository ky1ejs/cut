import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers } from './__generated__/graphql';
import { readFileSync } from 'fs';
import movieResolver from './resolvers/movie-resolver';
import genreResolver from './resolvers/genre-resolver';
import searchResolver from './resolvers/search-resolver';

const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

const resolvers: Resolvers = {
  Query: {
    movies: movieResolver,
    search: (_, args) => { return searchResolver(args) }
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

app.get('/test', (req, res) => {
  res.send('Hello from Express!');
})

const port = process.env.PORT || 4000;
await new Promise<void>((resolve) => httpServer.listen({ port }, resolve));
console.log(`📡 listening on port ${port}`);
