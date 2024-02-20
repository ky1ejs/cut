import { Movie } from "@prisma/client";
import { MutationAddToWatchListArgs } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import fetchTmdbMovie from "../../datasources/fetchTmdbMovie";
import importTmbdMovie from "../../db/tmdbImporter";
import prisma from "../../prisma";

export default async function addToWatchList(context: GraphQLContext, args: MutationAddToWatchListArgs) {
  if (!context.user) {
    throw new Error('Unauthorized');
  }

  const [provider, movieId] = args.movieId.split(':');

  let cutMovie: Movie
  switch (provider) {
    case 'TMDB':
      const movie = await fetchTmdbMovie(movieId);
      console.log("Movie");
      cutMovie = await importTmbdMovie(movie);
      console.log("Added");
      break;
    case 'CUT':
      const m = await prisma.movie.findUnique({
        where: {
          id: movieId
        }
      });
      if (!m) {
        throw new Error('Movie not found');
      }
      cutMovie = m;
      break;
    default:
      throw new Error('Provider not supported');
  }

  await prisma.watchList.upsert({
    where: { movieId_userId: { movieId: cutMovie.id, userId: context.user.id } },
    create: { userId: context.user.id, movieId: cutMovie.id },
    update: {}
  });

  return true
}
