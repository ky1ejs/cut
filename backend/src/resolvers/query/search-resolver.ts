import axios from 'axios';
import { Genre, MovieResolvers, QueryResolvers, QuerySearchArgs, Resolvers } from '../../__generated__/graphql';
import { getImageBaseUrl } from '../../tmbd/image_base';
import { Movie } from '@prisma/client';
import prisma from '../../prisma';
import Provider from '../../types/providers';

const searchResolver: QueryResolvers["search"] = async (_, args) => {
  try {
    const result = await axios.get(`https://api.themoviedb.org/3/search/movie?query=${args.term}&include_adult=true&language=en-US&page=1`, {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
    const tmdbGenres = await fetchGenres();
    return result.data.results.map((movie: any) => {
      const genres: Genre[] = movie.genre_ids.map((id: number) =>
        tmdbGenres.find((g) => g.tmdbId === id) ?? null
      ).filter((g: (Genre | null)) => g !== null);
      return {
        id: `${Provider.TMDB}:${movie.id.toString()}`,
        title: movie.title,
        poster_url: getImageBaseUrl() + movie.poster_path,
        release_data: movie.release_date,
        genres,
        mainGenre: genres[0],
      }
    });
  } catch (error) {
    console.error(error);
    throw error;
  }
}

let genres: { id: number, tmdbId: number, name: string }[] | undefined;

async function fetchGenres() {
  if (genres) {
    return genres;
  }
  const tmdbGenres = await prisma.genre.findMany({
    where: {
      tmdbId: {
        not: null
      }
    },
    include: {
      locales: {
        where: {
          language_ISO_639_1: 'en'
        }
      }
    }
  });
  const mappedGenres = tmdbGenres.map((genre) => ({
    id: genre.id,
    tmdbId: genre.tmdbId!,
    name: genre.locales[0].name
  }));
  genres = mappedGenres;
  return mappedGenres;
}

export default searchResolver;
