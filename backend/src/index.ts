import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers } from './generated/graphql';
import { readFileSync } from 'fs';

const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

const resolvers: Resolvers = {
  Query: {
    movies: () => [
      { title: 'Inception', director: 'Christopher Nolan' },
      { title: 'Interstellar', director: 'Christopher Nolan' },
    ],
  },
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

await new Promise<void>((resolve) => httpServer.listen({ port: 3000 }, resolve));
console.log(`🚀 Server ready at http://localhost:4000/`);
