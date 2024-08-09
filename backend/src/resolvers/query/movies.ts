import { QueryResolvers } from '../../__generated__/graphql';
import prisma from '../../prisma';
import contentDbToGqlMapper, { contentInclude } from '../mappers/contentDbToGqlMapper';

const contentCollectionResolver: QueryResolvers["contentCollection"] = async (_, args) => {
  const result = await prisma.contentCollection.findMany({
    where: {
      type: args.collection
    },
    include: {
      content: {
        include: contentInclude
      }
    }
  });
  return result.map((collectionEntry) => contentDbToGqlMapper(collectionEntry.content));
}

export default contentCollectionResolver;
