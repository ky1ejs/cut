import { Genre, Movie, MovieGenre, MovieImage, Prisma } from "@prisma/client";
import { MovieInterface as GqlMovie } from "../../__generated__/graphql";
import Provider from "../../types/providers";

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

export const movieInclude = {
  images: true,
  mainGenre: {
    include: {
      locales: {
        where: {
          language_ISO_639_1: "en"
        }
      }
    }
  },
  genres: {
    include: {
      genre: {
        include: {
          locales: {
            where: {
              language_ISO_639_1: "en"
            }
          }
        }
      }
    }
  }
}

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
    mainGenre: mainGenre,
    url: "https://cut.watch/movie/" + movie.id,
    allIds: [
      movie.id,
      movie.tmdbId ? `${Provider.TMDB}:${movie.tmdbId}` : undefined
    ].filter((id) => id !== undefined) as string[]
  }
}