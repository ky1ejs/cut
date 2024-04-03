import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  overwrite: true,
  schema: "graphql/schema.graphql",
  generates: {
    'src/__generated__/graphql/index.ts': {
      plugins: [
        'typescript',
        'typescript-resolvers', {
          add: {
            content: "import { DeepPartial } from 'utility-types';"
          }
        }
      ],
      config: {
        defaultMapper: 'DeepPartial<{T}>',
        contextType: "../../graphql/GraphQLContext#GraphQLContext"
      },
    },
  },
};
export default config;
