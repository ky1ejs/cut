import { Movie } from "@prisma/client";
import { MutationAddToWatchListArgs, MutationResolvers, Resolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import fetchTmdbMovie from "../../datasources/fetchTmdbMovie";
import importTmbdMovie from "../../db/tmdbImporter";
import prisma from "../../prisma";
import { markAsUntransferable } from "worker_threads";

const addToWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.user) {
    throw new Error('Unauthorized');
  }

  const [providerOrCutId, parsedId] = args.movieId.split(':');
  console.log("Provider: ", providerOrCutId);
  console.log("ParsedId: ", parsedId);

  let movieId: string
  switch (providerOrCutId) {
    case 'TMDB':
      const movie = await fetchTmdbMovie(parsedId);
      console.log("Movie");
      movieId = (await importTmbdMovie(movie, "en", "US")).id;
      console.log("Added");
      break;
    default:
      movieId = parsedId ?? providerOrCutId;
      break;
  }

  await prisma.watchList.upsert({
    where: { movieId_userId: { movieId, userId: context.user.id } },
    create: { userId: context.user.id, movieId },
    update: {}
  });

  return {
    true: true,
    id: movieId
  }
}

export default addToWatchList;
