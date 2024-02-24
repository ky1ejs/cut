import { Genre, Movie } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";

export default async function watchList(context: GraphQLContext) {
  const { user } = context;
  if (!user) {
    throw new Error('Not authenticated');
  }
  return prisma.watchList.findMany({
    where: {
      userId: user.id
    },
    include: {
      movie: {
        include: {
          images: true,
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
  }).then((watchList) => watchList.map((watchListItem) => {
    const genres: Genre[] = watchListItem.movie.genres.map((genre) => {
      return {
        id: genre.genre.id,
        name: genre.genre.locales[0].name
      }
    });
    return {
      id: watchListItem.movie.id,
      title: watchListItem.movie.originalTitle,
      poster_url: watchListItem.movie.images[0].url,
      release_date: watchListItem.movie.releaseDate?.toString(),
      genres: genres,
      isOnWatchList: true
    }
  }));
}