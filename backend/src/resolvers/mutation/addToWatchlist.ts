
import { GraphQLError } from "graphql";
import { ContentType, MutationResolvers } from "../../__generated__/graphql";
import importTmbdContent from "../../db/tmdbImporter";
import prisma from "../../prisma";
import ContentID from "../../types/ContentID";
import Provider from "../../types/providers";

const addToWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.userDevice && !context.annonymousUserDevice) {
    throw new GraphQLError('Unauthorized');
  }

  const id = ContentID.fromString(args.contentId);
  let cutId: string;
  if (id.provider === Provider.TMDB) {
    let content: any
    switch (id.type) {
      case ContentType.Movie:
        content = await context.dataSources.tmdb.fetchMovie(id.id);
        break;
      case ContentType.TvShow:
        content = await context.dataSources.tmdb.fetchTvShow(id.id);
        break;
      default:
        throw new GraphQLError(`Invalid type ${id.type}`);
    }
    cutId = (await importTmbdContent(content, "en", "US", id.dbContentType())).id;
  } else {
    cutId = id.id;
  }

  if (context.userDevice) {
    await prisma.watchList.upsert({
      where: { contentId_userId: { contentId: cutId, userId: context.userDevice.user.id } },
      create: { userId: context.userDevice.user.id, contentId: cutId },
      update: {}
    });
  } else if (context.annonymousUserDevice) {
    await prisma.annonymousWatchList.upsert({
      where: { contentId_userId: { contentId: cutId, userId: context.annonymousUserDevice.user.id } },
      create: { userId: context.annonymousUserDevice.user.id, contentId: cutId },
      update: {}
    });
  } else {
    throw new GraphQLError('Runtime error');
  }

  return {
    true: true,
    id: new ContentID(id.type, undefined, cutId).toString()
  }
}

export default addToWatchList;
