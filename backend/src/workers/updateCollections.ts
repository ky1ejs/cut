import axios from "axios";
import importTmbdContent from "../db/tmdbImporter";
import { CollectionType, ContentType, Content } from "@prisma/client";
import prisma from "../prisma";

const CollectionEndpoints: CollectionConfig[] = [
  {
    type: CollectionType.TRENDING_WEEKLY,
    movieEndpoint: 'https://api.themoviedb.org/3/trending/movie/week',
    tvEndpoint: 'https://api.themoviedb.org/3/trending/tv/week',
  },
  {
    type: CollectionType.TRENDING_DAILY,
    movieEndpoint: 'https://api.themoviedb.org/3/trending/movie/day',
    tvEndpoint: 'https://api.themoviedb.org/3/trending/tv/day',
  },
  {
    type: CollectionType.TOP_RATED,
    movieEndpoint: 'https://api.themoviedb.org/3/movie/top_rated',
    tvEndpoint: 'https://api.themoviedb.org/3/tv/top_rated',
  },
  {
    type: CollectionType.POPULAR,
    movieEndpoint: 'https://api.themoviedb.org/3/movie/popular',
    tvEndpoint: 'https://api.themoviedb.org/3/tv/popular',
  },
  {
    type: CollectionType.UPCOMING,
    movieEndpoint: 'https://api.themoviedb.org/3/movie/upcoming',
  },
  {
    type: CollectionType.NOW_PLAYING,
    movieEndpoint: 'https://api.themoviedb.org/3/movie/now_playing',
  },
];

type CollectionConfig = {
  type: CollectionType;
  tvEndpoint?: string;
  movieEndpoint?: string;
}

export async function updateAllCollections() {
  for (const config of CollectionEndpoints) {
    await updateCollection(config);
  }
}

async function callEndpoint(endpoint: string) {
  return axios.get(endpoint, {
    headers: {
      Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
      accept: 'application/json',
    }
  });
}


async function updateCollection(config: CollectionConfig) {
  if (!config.movieEndpoint && !config.tvEndpoint) {
    throw new Error(`No endpoint found for collection type ${config.type}`);
  }
  try {
    let collectionIds: string[] = []
    if (config.movieEndpoint) {
      const result = await callEndpoint(config.movieEndpoint);
      const storeMovies: Promise<Content>[] = result.data.results.map((movie: any) => importTmbdContent(movie, "en", "US", ContentType.MOVIE));
      collectionIds.push(...(await Promise.all(storeMovies)).map((movie) => movie.id));
    }
    if (config.tvEndpoint) {
      const result = await callEndpoint(config.tvEndpoint);
      const storeMovies: Promise<Content>[] = result.data.results.map((movie: any) => importTmbdContent(movie, "en", "US", ContentType.TV_SHOW));
      collectionIds.push(...(await Promise.all(storeMovies)).map((tvShow) => tvShow.id));
    }

    const currentCollectionIds = await prisma.contentCollection.findMany({
      where: {
        type: config.type,
      },
      select: {
        contentId: true
      }
    }).then((movies) => movies.map((content) => content.contentId));

    const idsNotInCollection = currentCollectionIds.filter((movieId) => !collectionIds.includes(movieId));
    await prisma.contentCollection.deleteMany({
      where: {
        type: config.type,
        contentId: {
          in: idsNotInCollection
        }
      }
    });

    const newIdsInCollection = collectionIds.filter((movieId) => !currentCollectionIds.includes(movieId));
    await prisma.contentCollection.createMany({
      data: newIdsInCollection.map((contentId) => ({
        contentId,
        type: config.type
      }))
    });
  } catch (error) {
    console.error(error);
    throw error;
  }
}
