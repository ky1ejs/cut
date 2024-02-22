import { MovieResolvers } from "../../__generated__/graphql";

const isOnWatchlistResolver: MovieResolvers["isOnWatchList"] = async (movie, _, context) => {
  if (!context.user) {
    return false
  }
  if (!movie.id) {
    return false
  }
  if (movie.isOnWatchList !== undefined) {
    return movie.isOnWatchList
  }
  return context.dataSources.watchList.getWatchlistStatusFor({ movieId: movie.id, userId: context.user.id });
}

export default isOnWatchlistResolver;
