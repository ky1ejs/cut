import axios from 'axios';

const movieResolver = async () => {
  try {
    const result = await axios.get('https://api.themoviedb.org/3/trending/movie/week', {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
    return result.data.results.map((movie: any) => ({
      title: movie.title,
      director: movie.original_language,
    }));
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export default movieResolver;
