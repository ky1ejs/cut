import axios from 'axios';
import { ContentType, Genre, QueryResolvers } from '../../__generated__/graphql';
import { getImageBaseUrl } from '../../tmbd/image_base';
import prisma from '../../prisma';
import Provider from '../../types/providers';
import ContentID from '../../types/ContentID';

const searchResolver: QueryResolvers["search"] = async (_, args) => {
  try {
    const result = await axios.get(`https://api.themoviedb.org/3/search/multi?query=${args.term}&include_adult=true&language=en-US&page=1`, {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
    const tmdbGenres = await fetchGenres();
    const filteredResults = result.data.results.filter((movie: any) => movie.media_type === 'movie' || movie.media_type === 'tv');
    return filteredResults.map((movie: any) => {
      const genres: Genre[] = movie.genre_ids.map((id: number) =>
        tmdbGenres.find((g) => g.tmdbId === id) ?? null
      ).filter((g: (Genre | null)) => g !== null);
      const type = movie.media_type === 'movie' ? ContentType.Movie : ContentType.TvShow;
      const id = new ContentID(type, Provider.TMDB, movie.id.toString()).toString();
      let release_data: Date | undefined;
      if (movie.release_date) {
        release_data = new Date(movie.release_date);
      }
      if (movie.first_air_date) {
        release_data = new Date(movie.first_air_date);
      }
      return {
        id,
        allIds: [id],
        title: movie.original_name || movie.original_title,
        poster_url: getImageBaseUrl() + movie.poster_path,
        releaseDate: release_data,
        genres,
        type,
        mainGenre: genres[0],
        url: `https://cut.watch/movie/${movie.id}`
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
