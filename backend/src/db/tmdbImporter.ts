import { Provider, Prisma, ImageType, Movie, ProviderMovieGenre } from "@prisma/client";
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

  const genreIds = parseGenreIds(movie);
  const firstGenreId = genreIds.length > 0 ? genreIds[0] : null;
  let mainGenre: ProviderMovieGenre | null = null;
  if (firstGenreId) {
    mainGenre = await prisma.providerMovieGenre.findUnique({
      where: {
        externalID_provider: {
          externalID: firstGenreId,
          provider: Provider.TMDB
        }
      }
    });
  }

  const cutMovie = tmdbMovieToCutMovie(movie, mainGenre ? movie.genreId : undefined);
  const posterUrl = `https://image.tmdb.org/t/p/original${movie.poster_path}`;
  const backdropUrl = `https://image.tmdb.org/t/p/original${movie.backdrop_path}`;
  const genres = await prisma.providerMovieGenre.findMany({
    where: {
      provider: Provider.TMDB,
      externalID: {
        in: genreIds
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

function tmdbMovieToCutMovie(tmdbMovie: any, mainGenreId: number | undefined): Prisma.MovieCreateInput {
  let cutMovie: Prisma.MovieCreateInput = {
    originalTitle: tmdbMovie.title,
    releaseDate: new Date(tmdbMovie.release_date),
    synopsis: tmdbMovie.overview,
    originalLanguage: tmdbMovie.original_language,
  }
  if (mainGenreId) {
    cutMovie.mainGenre = {
      connect: {
        id: mainGenreId
      }
    }
  }
  return cutMovie;
}

function parseGenreIds(movie: any): string[] {
  if (movie.genre_ids) {
    return movie.genre_ids.map((id: number) => id.toString());
  }
  if (movie.genres) {
    return movie.genres.map((genre: any) => genre.id.toString());
  }
  return []
}