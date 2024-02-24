import axios from "axios";

export default async function fetchTmdbMovie(id: string) {
  const response = await axios.get(`https://api.themoviedb.org/3/movie/${id}`, {
    headers: {
      Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
      accept: 'application/json',
    }
  });
  return response.data
}
