import axios from 'axios';
import { QuerySearchArgs } from '../__generated__/graphql';
import { getImageBaseUrl } from '../tmbd/image_base';

const searchResolver = async (query: Partial<QuerySearchArgs>) => {
  try {
    const result = await axios.get(`https://api.themoviedb.org/3/search/movie?query=${query.term}&include_adult=true&language=en-US&page=1`, {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
    return result.data.results.map((movie: any) => ({
      id: movie.id,
      title: movie.title,
      director: movie.original_language,
      poster_url: getImageBaseUrl() + movie.poster_path,
      release_data: movie.release_date,
      genres: movie.genre_ids.map((id: number) => ({ id })),
    }));
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export default searchResolver;
