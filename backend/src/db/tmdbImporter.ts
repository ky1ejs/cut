import { Provider, Prisma, ImageType, Movie } from "@prisma/client";
import prisma from "../prisma"
import { randomUUID } from "crypto";

export default async function importTmbdMovie(movie: any): Promise<Movie> {
  const tmdbId = movie.id.toString();
  const cutProviderRecord = await prisma.movieProvider.findUnique({
    where: {
      externalId_provider: {
        externalId: tmdbId,
        provider: Provider.TMDB,
      }
    }
  });

  const firstGenreId = movie.genre_ids[0].toString();
  const mainGenre = await prisma.providerMovieGenre.findUnique({
    where: {
      externalID_provider: {
        externalID: firstGenreId,
        provider: Provider.TMDB
      }
    }
  });

  if (!mainGenre) {
    throw new Error(`Genre with id ${firstGenreId} not found`);
  }

  const cutMovie = tmdbMovieToCutMovie(movie, mainGenre.genreId);
  const posterUrl = `https://image.tmdb.org/t/p/original${movie.poster_path}`;
  const backdropUrl = `https://image.tmdb.org/t/p/original${movie.backdrop_path}`;
  const tmdbGenreIds: string[] = movie.genre_ids.map((genre: any) => genre.toString());
  const genres = await prisma.providerMovieGenre.findMany({
    where: {
      provider: Provider.TMDB,
      externalID: {
        in: tmdbGenreIds
      }
    }
  }).then((r) => r.map((g) => g.genreId));

  let resultMovie: Movie
  console.log(cutProviderRecord)
  if (cutProviderRecord) {
    resultMovie = await prisma.movie.update({
      where: {
        id: cutProviderRecord.movieId
      },
      data: cutMovie
    });
    // todo update imaage and genres
  } else {
    const movieId = randomUUID().toString()
    resultMovie = await prisma.movie.create({
      data: {
        ...cutMovie,
        id: movieId,
        mainProvider: {
          create: {
            movieId: movieId,
            externalId: tmdbId,
            provider: Provider.TMDB,
          }
        },
        images: {
          createMany: {
            data: [
              {
                type: ImageType.POSTER,
                url: posterUrl
              },
              {
                type: ImageType.BACKDROP,
                url: backdropUrl
              }
            ],
            skipDuplicates: true
          }

        },
        genres: {
          create: genres.map((genreId) => ({
            genreId
          }))
        }
      },
    });
  }
  return resultMovie
}

function tmdbMovieToCutMovie(tmdbMovie: any, mainGenreId: number): Prisma.MovieCreateInput {
  return {
    originalTitle: tmdbMovie.title,
    releaseDate: new Date(tmdbMovie.release_date),
    synopsis: tmdbMovie.overview,
    originalLanguage: tmdbMovie.original_language,
    mainGenreId: mainGenreId
  }
}