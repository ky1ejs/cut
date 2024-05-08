import { QueryResolvers } from '../../__generated__/graphql';
import prisma from '../../prisma';
import dbMovieToGqlMovie, { movieInclude } from '../mappers/dbMovieToGqlMovie';

const moviesResolver: QueryResolvers["movies"] = async (_, args) => {
  const result = await prisma.movieCollection.findMany({
    where: {
      type: args.collection
    },
    include: {
      movie: {
        include: movieInclude
      }
    }
  });
  return result.map((collectionEntry) => dbMovieToGqlMovie(collectionEntry.movie));
}

export default moviesResolver;
