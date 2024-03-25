
import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import fetchTmdbMovie from "../../datasources/fetchTmdbMovie";
import importTmbdMovie from "../../db/tmdbImporter";
import prisma from "../../prisma";

const addToWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.userDevice && !context.annonymousUserDevice) {
    throw new GraphQLError('Unauthorized');
  }

  const [providerOrCutId, parsedId] = args.movieId.split(':');

  let movieId: string
  switch (providerOrCutId) {
    case 'TMDB':
      const movie = await fetchTmdbMovie(parsedId);
      movieId = (await importTmbdMovie(movie, "en", "US")).id;
      break;
    default:
      movieId = parsedId ?? providerOrCutId;
      break;
  }

  if (context.userDevice) {
    await prisma.watchList.upsert({
      where: { movieId_userId: { movieId, userId: context.userDevice.user.id } },
      create: { userId: context.userDevice.user.id, movieId },
      update: {}
    });
  } else if (context.annonymousUserDevice) {
    await prisma.annonymousWatchList.upsert({
      where: { movieId_userId: { movieId, userId: context.annonymousUserDevice.user.id } },
      create: { userId: context.annonymousUserDevice.user.id, movieId },
      update: {}
    });
  } else {
    throw new GraphQLError('Runtime error');
  }

  return {
    true: true,
    id: movieId
  }
}

export default addToWatchList;
