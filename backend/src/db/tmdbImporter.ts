import { Prisma, ImageType, Genre, ContentType } from "@prisma/client";
import prisma from "../prisma"
import { randomUUID } from "crypto";
import { ResolvedContent } from "../resolvers/mappers/contentDbToGqlMapper";

export default async function importTmbdContent(content: any, lang: string, country: string, type: ContentType): Promise<ResolvedContent> {

  let cutContent = await prisma.content.findUnique({
    where: {
      tmdbId: content.id
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

  if (!cutContent) {
    const genreIds: number[] = content.genre_ids || content.genres.map((g: any) => g.id) || [];
    const firstGenreId = genreIds.length > 0 ? genreIds[0] : null;
    let mainGenre: Genre | null = null;
    if (firstGenreId) {
      mainGenre = await prisma.genre.findUnique({
        where: {
          tmdbId: firstGenreId
        }
      });
    }

    const posterUrl = `https://image.tmdb.org/t/p/original${content.poster_path}`;
    const backdropUrl = `https://image.tmdb.org/t/p/original${content.backdrop_path}`;

    const genres = genreIds.length > 0 ? await prisma.genre.findMany({
      where: {
        tmdbId: {
          in: genreIds
        }
      }
    }) : []

    const parsedMovie = tmdbMovieToCutMovie(content, mainGenre ? mainGenre.id : undefined, type);
    const movieId = randomUUID().toString()
    cutContent = await prisma.content.create({
      data: {
        ...parsedMovie,
        id: movieId,
        tmdbId: content.id,
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
  return cutContent
}

function tmdbMovieToCutMovie(tmdbMovie: any, mainGenreId: number | undefined, contentType: ContentType): Prisma.ContentCreateInput {
  const releaseDateString = contentType === ContentType.MOVIE ? tmdbMovie.release_date : tmdbMovie.first_air_date
  let cutMovie: Prisma.ContentCreateInput = {
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
