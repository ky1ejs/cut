# Bootstraing the Backend

Key links, learnings and copy-pastes for setting up the backend.

## GraphQL set-up
Took various things from these links, but mainly the top-level `await` tsconfig.json config. Also took the `ApolloServerPluginDrainHttpServer` approach from these.
  - https://www.apollographql.com/docs/apollo-server/getting-started/#step-2-install-dependencies - tsconfig.json on this page
  - https://www.apollographql.com/docs/apollo-server/api/plugin/drain-http-server
  - https://www.apollographql.com/docs/apollo-server/api/express-middleware

## Using ts-node and `"type": "module"` was giving "unrecognized extension" error
Fixed by compiling and running the compiled javascript, as the apollo docs outline above. 

I would fight with ts-node for a bit longer to get this working, but I can't be bothered right now.
