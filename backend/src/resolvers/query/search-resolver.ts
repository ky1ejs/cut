import axios from 'axios';
import { QueryResolvers } from '../../__generated__/graphql';
import tmdbMovieToGqlMapper from '../mappers/tmdbMovieToGqlMapper';
import { DeepPartial } from 'utility-types';
import { Movie } from '@prisma/client';

const searchResolver: QueryResolvers["search"] = async (_, args) => {
  const result = await axios.get(`https://api.themoviedb.org/3/search/multi?query=${args.term}&include_adult=true&language=en-US&page=1`, {
    headers: {
      Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
      accept: 'application/json',
    }
  });
  const mappedResults: DeepPartial<Movie>[] = await Promise.all(result.data.results.map(tmdbMovieToGqlMapper))
    .then((movies) => movies.filter((m) => m !== null));
  return mappedResults
}

export default searchResolver;
