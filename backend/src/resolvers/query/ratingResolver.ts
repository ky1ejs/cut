import { GraphQLError } from "graphql";
import { MovieInterfaceResolvers, MovieResolvers } from "../../__generated__/graphql";

const ratingResolver: MovieInterfaceResolvers["rating"] = async (movie, _, context) => {
  if (movie.rating !== undefined) {
    return movie.rating
  }
  if (context.userDevice) {
    if (!movie.id) {
      return null
    }
    return await context.dataSources.ratingDataLoader.getRating({ movieId: movie.id, userId: context.userDevice.user.id });
  }
  if (context.annonymousUserDevice) {
    if (!movie.id) {
      return null
    }
    return await context.dataSources.annonymousRatingDataLoader.getRating({ movieId: movie.id, userId: context.annonymousUserDevice.user.id });
  }
  throw new GraphQLError("Unauthorized")
}

export default ratingResolver;
