import { GraphQLError } from "graphql";
import { ContentInterfaceResolvers } from "../../__generated__/graphql";

const isOnWatchlistResolver: ContentInterfaceResolvers["isOnWatchList"] = async (movie, _, context) => {
  if (movie.isOnWatchList !== undefined) {
    return movie.isOnWatchList
  }
  if (context.userDevice) {
    if (!movie.id) {
      return false
    }
    return await context.dataSources.watchList.getWatchlistStatusFor({ contentId: movie.id, userId: context.userDevice.user.id });
  }
  if (context.annonymousUserDevice) {
    if (!movie.id) {
      return false
    }
    return await context.dataSources.annonymousWatchList.getWatchlistStatusFor({ contentId: movie.id, userId: context.annonymousUserDevice.user.id });
  }
  throw new GraphQLError("Unauthorized")
}

export default isOnWatchlistResolver;
