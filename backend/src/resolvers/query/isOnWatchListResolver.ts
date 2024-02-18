import { Movie } from "../../__generated__/graphql";
import { GraphQLContext } from "../../boot";

const isOnWatchlistResolver = async (movie: Movie, context: GraphQLContext) => {
  if (!context.user) {
    return false;
  }
  return context.dataSources.watchList.getWatchlistStatusFor({ tmdbId: movie.id, userId: context.user.id });
}

export default isOnWatchlistResolver;