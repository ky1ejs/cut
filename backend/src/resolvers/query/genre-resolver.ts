import axios from "axios";
import { Genre, GenreMetadata } from "../../__generated__/graphql";

let GenreMap: Map<number, string> | undefined

async function genreResolver(parent: Genre): Promise<GenreMetadata> {
  try {
    if (!GenreMap) {
      const result = await axios.get('https://api.themoviedb.org/3/genre/movie/list', {
        headers: {
          Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
          accept: 'application/json',
        }
      })
      const map = new Map();
      result.data.genres.forEach((genre: any) => {
        map.set(genre.id, genre.name);
      })
      GenreMap = map;
    }
    const genreName = GenreMap.get(parent.id);
    if (!genreName) {
      throw new Error('Genre not found');
    }
    return { name: genreName };
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export default genreResolver;