import { Prisma, ImageType, Movie, Genre } from "@prisma/client";
import prisma from "../prisma"
import { randomUUID } from "crypto";

export default async function importTmbdMovie(movie: any): Promise<Movie> {
  let cutMovie = await prisma.movie.findUnique({
    where: {
      tmdbId: movie.id
    }
  });

  if (!cutMovie) {
    const genreIds = movie.genre_ids || movie.genres.map((g: any) => g.id) || [];
    const firstGenreId = genreIds.length > 0 ? genreIds[0] : null;
    let mainGenre: Genre | null = null;
    if (firstGenreId) {
      mainGenre = await prisma.genre.findUnique({
        where: {
          tmdbId: firstGenreId
        }
      });
    }

    const posterUrl = `https://image.tmdb.org/t/p/original${movie.poster_path}`;
    const backdropUrl = `https://image.tmdb.org/t/p/original${movie.backdrop_path}`;

    const genres = genreIds.length > 0 ? await prisma.genre.findMany({
      where: {
        id: {
          in: genreIds
        }
      }
    }) : []

    const parsedMovie = tmdbMovieToCutMovie(movie, mainGenre ? movie.genreId : undefined);
    const movieId = randomUUID().toString()
    cutMovie = await prisma.movie.create({
      data: {
        ...parsedMovie,
        id: movieId,
        tmdbId: movie.id,
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
          create: genres.map((genre) => ({
            genreId: genre.id
          }))
        }
      },
    });
  }
  return cutMovie
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
