# Bootstraing the Backend

Key links, learnings and copy-pastes for setting up the backend.

## GraphQL set-up
Took various things from these links, but mainly the top-level `await` tsconfig.json config. Also took the `ApolloServerPluginDrainHttpServer` approach from these.
  - https://www.apollographql.com/docs/apollo-server/getting-started/#step-2-install-dependencies - tsconfig.json on this page
  - https://www.apollographql.com/docs/apollo-server/api/plugin/drain-http-server
  - https://www.apollographql.com/docs/apollo-server/api/express-middleware

## Using ts-node and `"type": "module"` was giving "unrecognized extension" error
Fixed by compiling and running the compiled javascript, as the apollo docs outline above. 

Found this comment GitHub comment:
https://github.com/TypeStrong/ts-node/discussions/1781#discussioncomment-4677258

Also found that this is perhaps a ts-node + node20 issue:
https://www.reddit.com/r/typescript/comments/15sk2mt/comment/jwfa35g/?utm_source=share&utm_medium=web2x&context=3
