import { GraphQLError } from "graphql";
import { ContentInterfaceResolvers } from "../../__generated__/graphql";

const ratingResolver: ContentInterfaceResolvers["currentUserRating"] = async (content, _, context) => {
  if (content.currentUserRating !== undefined) {
    return content.currentUserRating
  }
  if (context.userDevice) {
    if (!content.id) {
      return null
    }
    return await context.dataSources.ratingDataLoader.getRating({ contentId: content.id, userId: context.userDevice.user.id });
  }
  if (context.annonymousUserDevice) {
    if (!content.id) {
      return null
    }
    return await context.dataSources.annonymousRatingDataLoader.getRating({ contentId: content.id, userId: context.annonymousUserDevice.user.id });
  }
  return null;
}

export default ratingResolver;
