import { Prisma, ImageType, Movie, Genre, ContentType } from "@prisma/client";
import prisma from "../prisma"
import { randomUUID } from "crypto";
import { ResolvedMovie } from "../resolvers/mappers/dbMovieToGqlMovie";

export default async function importTmbdMovie(movie: any, lang: string, country: string, type: ContentType): Promise<ResolvedMovie> {
  let cutMovie = await prisma.movie.findUnique({
    where: {
      tmdbId: movie.id
    },
    include: {
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
  });

  if (!cutMovie) {
    const genreIds: number[] = movie.genre_ids || movie.genres.map((g: any) => g.id) || [];
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
        tmdbId: {
          in: genreIds
        }
      }
    }) : []

    const parsedMovie = tmdbMovieToCutMovie(movie, mainGenre ? mainGenre.id : undefined, type);
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
                url: posterUrl,
                language_ISO_639_1: lang,
                country_ISO_3166_1: country
              },
              {
                type: ImageType.BACKDROP,
                url: backdropUrl,
                language_ISO_639_1: lang,
                country_ISO_3166_1: country
              }
            ],
            skipDuplicates: true
          }

        },
        genres: {
          createMany: {
            data: genres.map((genre) => ({ genreId: genre.id })),
            skipDuplicates: false
          }
        }
      },
      include: {
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
    });
  }
  return cutMovie
}

function tmdbMovieToCutMovie(tmdbMovie: any, mainGenreId: number | undefined, contentType: ContentType): Prisma.MovieCreateInput {
  const releaseDateString = contentType === ContentType.MOVIE ? tmdbMovie.release_date : tmdbMovie.first_air_date
  let cutMovie: Prisma.MovieCreateInput = {
    originalTitle: contentType === ContentType.MOVIE ? tmdbMovie.title : tmdbMovie.name,
    releaseDate: releaseDateString ? new Date(releaseDateString) : null,
    synopsis: tmdbMovie.overview,
    originalLanguage: tmdbMovie.original_language,
    contentType,
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
