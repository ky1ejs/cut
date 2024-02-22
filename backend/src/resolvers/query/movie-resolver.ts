import { QueryResolvers } from '../../__generated__/graphql';
import prisma from '../../prisma';

const movieResolver: QueryResolvers["movies"] = async (_, args) => {
  const movies = await prisma.movieCollection.findMany({
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
                  language: "en"
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
                      language: "en"
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
  return movies.map((movie) => {
    const genres = movie.movie.genres.map((genre) => ({
      id: genre.genre.id,
      name: genre.genre.locales[0].name
    }));
    const mainGenre = movie.movie.mainGenre ? {
      id: movie.movie.mainGenre.id,
      name: movie.movie.mainGenre.locales[0].name
    } : null
    return {
      id: movie.movie.id,
      title: movie.movie.originalTitle,
      poster_url: movie.movie.images[0].url,
      release_date: movie.movie.releaseDate?.toString(),
      genres: genres,
      mainGenre,
    }
  });
}

export default movieResolver;
