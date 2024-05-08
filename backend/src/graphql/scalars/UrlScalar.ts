import e from "express";
import { GraphQLScalarType } from "graphql";

const urlScalar = new GraphQLScalarType({
  name: 'Url',
  description: 'Url custom scalar type',
  serialize(value) {
    if (typeof value === 'string') {
      return value;
    }
    throw new Error('GraphQL Url Scalar serializer expected a `string`');
  },
  parseValue(value) {
    if (typeof value === 'string') {
      return value;
    }
    throw new Error('GraphQL Url Scalar parser expected a `string`');
  },
});

export default urlScalar;
