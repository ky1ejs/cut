import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";
import ContentID from "../../types/ContentID";
import Provider from "../../types/providers";

const removeFromWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.userDevice && !context.annonymousUserDevice) {
    throw new Error('Unauthorized');
  }

  const contentId = ContentID.fromString(args.contentId);
  let id: string;
  if (contentId.provider === Provider.TMDB) {
    const movie = await prisma.content.findUnique({
      where: {
        tmdbId: parseInt(contentId.id)
      }
    });
    if (!movie) {
      throw new Error('Movie not found');
    }
    id = movie.id;
  } else {
    id = contentId.id;
  }

  if (context.userDevice) {
    await prisma.watchList.delete({
      where: {
        contentId_userId: {
          contentId: id,
          userId: context.userDevice.user.id
        }
      }
    })
  } else if (context.annonymousUserDevice) {
    await prisma.annonymousWatchList.delete({
      where: {
        contentId_userId: {
          contentId: id,
          userId: context.annonymousUserDevice.user.id
        }
      }
    })
  } else {
    throw new GraphQLError('Runtime error');
  }

  return {
    true: true,
    id: contentId.toString()
  }
}

export default removeFromWatchList;
