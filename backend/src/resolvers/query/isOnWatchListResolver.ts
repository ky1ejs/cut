import { MovieInterface, MovieInterfaceResolvers, MovieResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";

const isOnWatchlistResolver: MovieInterfaceResolvers["isOnWatchList"] = async (movie, _, context) => {
  console.log('isOnWatchlistResolver');
  if (!context.user) {
    return false
  }
  if (!movie.id) {
    return false
  }
  if (movie.isOnWatchList !== undefined) {
    return movie.isOnWatchList
  }
  return await context.dataSources.watchList.getWatchlistStatusFor({ movieId: movie.id, userId: context.user.id });
}

export default isOnWatchlistResolver;
