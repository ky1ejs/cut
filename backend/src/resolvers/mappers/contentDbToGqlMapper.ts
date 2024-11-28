import { Genre, Content, ContentGenre, ContentImage } from "@prisma/client";
import { ContentInterface } from "../../__generated__/graphql";
import Provider from "../../types/providers";
import { DeepPartial } from "utility-types";
import dbContentTypeToGqlContentType from "./dbContentTypeToGqlContentType";
import ContentID from "../../types/ContentID";

export type ResolvedGenre = Genre & {
  locales: {
    name: string;
  }[];
}

export type ResolvedContentGenre = ContentGenre & {
  genre: ResolvedGenre
}

export type ResolvedContent = Content & {
  images: ContentImage[];
  mainGenre: ResolvedGenre | null;
  genres: ResolvedContentGenre[];
};

export const contentInclude = {
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

export default function contentDbToGqlMapper(content: ResolvedContent): DeepPartial<ContentInterface> {
  const mainGenre = content.mainGenre ? {
    id: content.mainGenre.id,
    name: content.mainGenre.locales[0].name
  } : null
  const cutId = new ContentID(dbContentTypeToGqlContentType(content.contentType), Provider.CUT, content.id)
  const tmdbId = content.tmdbId ? new ContentID(dbContentTypeToGqlContentType(content.contentType), Provider.TMDB, content.tmdbId.toString()) : undefined
  let poster_url: string | null = null;
  if (content.images.length > 0) {
    poster_url = content.images[0].url;
  }
  return {
    id: cutId.toString(),
    title: content.originalTitle,
    poster_url,
    releaseDate: content.releaseDate,
    genres: content.genres.map((g) => ({
      id: g.genre.id,
      name: g.genre.locales[0].name
    })),
    mainGenre: mainGenre,
    url: "https://cut.watch/content/" + content.id,
    type: dbContentTypeToGqlContentType(content.contentType),
    allIds: [
      cutId.toString(),
      tmdbId?.toString()
    ].filter((id) => id !== undefined) as string[]
  }
}