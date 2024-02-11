# Bootstraing the Backend

Key links, learnings and copy-pastes for setting up the backend.

## GraphQL set-up
Took various things from these links, but mainly the top-level `await` tsconfig.json config. Also took the `ApolloServerPluginDrainHttpServer` approach from these.
  - https://www.apollographql.com/docs/apollo-server/getting-started/#step-2-install-dependencies - tsconfig.json on this page
  - https://www.apollographql.com/docs/apollo-server/api/plugin/drain-http-server
  - https://www.apollographql.com/docs/apollo-server/api/express-middleware

## Using ts-node and `"type": "module"` was giving "unrecognized extension" error
### Before Using Docker
Fixed by compiling and running the compiled javascript, as the apollo docs outline above. 

Found this comment GitHub comment which tells you to update your `tsconfig.json`:
https://github.com/TypeStrong/ts-node/discussions/1781#discussioncomment-4677258

Additionally, you have to start node like this:
```cli
  node --loader ts-node/esm src/index.ts
```

and you need to set `module` in the `tsconfig.json` to be `ES2022` and the `type` in the `package.json` to `module` (sadly I can't remember where I found those points from, but I saw them again and again on StackOverflow, ChatGPT tec. etc.)

Also found that this is perhaps a ts-node + node20 issue:
https://www.reddit.com/r/typescript/comments/15sk2mt/comment/jwfa35g/?utm_source=share&utm_medium=web2x&context=3

### After Using Docker
Despite the above fixes in place, I would get `ERR_MODULE_NOT_FOUND` when running in a Docker container, saying that the first import could not be found. Manually editing the import to include ".js", fixed the issue, but that is undesirable.

The solution to this was to use `ts-node` and `typescript` in production and include all the TS source in the image instead of just the compiled JS.

Without much trying on my part, this led to an image size of around 470Mb.

This whole journey came about because I was trying to use top-level await, which I copied from the Apollo Server example. After all this headeche and realizing that it very likely bloats the docker image (which is important now that I'm running on Fly.io to reduce costs), I'm going to get rid of top-level await and go back to `CommonJS` instead of `ES2022`.
