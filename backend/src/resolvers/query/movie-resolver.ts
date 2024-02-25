import { QueryResolvers } from '../../__generated__/graphql';
import prisma from '../../prisma';
import dbMovieToGqlMovie from '../helpers/dbMovieToGqlMovie';

const moviesResolver: QueryResolvers["movies"] = async (_, args) => {
  const result = await prisma.movieCollection.findMany({
    where: {
      type: args.collection
    },
    include: {
      movie: {
        include: {
          images: true,
          mainGenre: {
            include: {
              locales: {
                where: {
                  language_ISO_639_1: "en"
                }
              }
            }
          },
          genres: {
            include: {
              genre: {
                include: {
                  locales: {
                    where: {
                      language_ISO_639_1: "en"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  });
  return result.map((collectionEntry) => dbMovieToGqlMovie(collectionEntry.movie));
}

export default moviesResolver;
