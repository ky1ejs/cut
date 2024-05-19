import { ContentType, Genre, Movie, MovieGenre, MovieImage, Prisma } from "@prisma/client";
import { MovieInterface as GqlMovie, ContentType as GqlContentType } from "../../__generated__/graphql";
import Provider from "../../types/providers";
import { DeepPartial } from "utility-types";
import dbContentTypeToGqlContentType from "./dbContentTypeToGqlContentType";
import ContentID from "../../types/ContentID";

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

export default function dbMovieToGqlMovie(movie: ResolvedMovie): DeepPartial<GqlMovie> {
  const mainGenre = movie.mainGenre ? {
    id: movie.mainGenre.id,
    name: movie.mainGenre.locales[0].name
  } : null
  const cutId = new ContentID(dbContentTypeToGqlContentType(movie.contentType), Provider.CUT, movie.id)
  const tmdbId = movie.tmdbId ? new ContentID(dbContentTypeToGqlContentType(movie.contentType), Provider.TMDB, movie.tmdbId.toString()) : undefined
  let poster_url: string | null = null;
  if (movie.images.length > 0) {
    poster_url = movie.images[0].url;
  }
  return {
    id: cutId.toString(),
    title: movie.originalTitle,
    poster_url,
    releaseDate: movie.releaseDate,
    genres: movie.genres.map((g) => ({
      id: g.genre.id,
      name: g.genre.locales[0].name
    })),
    mainGenre: mainGenre,
    url: "https://cut.watch/movie/" + movie.id,
    type: dbContentTypeToGqlContentType(movie.contentType),
    allIds: [
      cutId.toString(),
      tmdbId?.toString()
    ].filter((id) => id !== undefined) as string[]
  }
}