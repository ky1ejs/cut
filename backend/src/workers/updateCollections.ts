import axios from "axios";
import importTmbdMovie from "../db/tmdbImporter";
import { CollectionType, Movie } from "@prisma/client";
import prisma from "../prisma";

const CollectionEndpoints: Map<CollectionType, string> = new Map([
  [CollectionType.TRENDING_WEEKLY, 'https://api.themoviedb.org/3/trending/movie/week'],
  [CollectionType.TRENDING_DAILY, 'https://api.themoviedb.org/3/trending/movie/day'],
  [CollectionType.NOW_PLAYING, 'https://api.themoviedb.org/3/movie/now_playing'],
  [CollectionType.POPULAR, 'https://api.themoviedb.org/3/movie/top_rated'],
  [CollectionType.TOP_RATED, 'https://api.themoviedb.org/3/movie/popular'],
  [CollectionType.UPCOMING, 'https://api.themoviedb.org/3/movie/upcoming'],
]);

export async function updateAllCollections() {
  const collectionTypes = Array.from(CollectionEndpoints.keys());
  for (const collection of collectionTypes) {
    await updateCollection(collection);
  }
}

async function updateCollection(collection: CollectionType) {
  const endpoint = CollectionEndpoints.get(collection);
  if (!endpoint) {
    throw new Error(`No endpoint found for collection type ${collection}`);
  }
  try {
    const result = await axios.get(endpoint, {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
    const storeMovies: Promise<Movie>[] = result.data.results.map((movie: any) => importTmbdMovie(movie));
    const latestCollectionIds = (await Promise.all(storeMovies)).map((movie) => movie.id);

    const currentCollectionIds = await prisma.movieCollection.findMany({
      where: {
        type: collection,
      },
      select: {
        movieId: true
      }
    }).then((movies) => movies.map((movie) => movie.movieId));

    const idsNotInCollection = currentCollectionIds.filter((movieId) => !latestCollectionIds.includes(movieId));
    await prisma.movieCollection.deleteMany({
      where: {
        type: collection,
        movieId: {
          in: idsNotInCollection
        }
      }
    });

    const newIdsInCollection = latestCollectionIds.filter((movieId) => !currentCollectionIds.includes(movieId));
    await prisma.movieCollection.createMany({
      data: newIdsInCollection.map((movieId) => ({
        movieId,
        type: collection
      }))
    });


  } catch (error) {
    console.error(error);
    throw error;
  }
}
