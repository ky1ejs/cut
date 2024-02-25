import { Genre, Movie, MovieGenre, MovieImage } from "@prisma/client";
import { MovieInterface as GqlMovie } from "../../__generated__/graphql";

export type ResolvedGenre = Genre & {
  locales: {
    name: string;
  }[];
}

export type ResolvedMovieGenre = MovieGenre & {
  genre: ResolvedGenre
}

export type ResolvedMovie = Movie & {
  images: MovieImage[];
  mainGenre: ResolvedGenre | null;
  genres: ResolvedMovieGenre[];
};

export default function dbMovieToGqlMovie(movie: ResolvedMovie): Partial<GqlMovie> {
  const mainGenre = movie.mainGenre ? {
    id: movie.mainGenre.id,
    name: movie.mainGenre.locales[0].name
  } : null
  return {
    id: movie.id,
    title: movie.originalTitle,
    poster_url: movie.images[0].url,
    release_date: movie.releaseDate?.toString(),
    genres: movie.genres.map((g) => ({
      id: g.genre.id,
      name: g.genre.locales[0].name
    })),
    mainGenre: mainGenre
  }
}