import { ContentType } from "../__generated__/graphql";
import prisma from "../prisma";
import Provider from "./providers";
import { ContentType as DbContentType } from "@prisma/client";

export default class ContentID {
  type: ContentType;
  provider?: Provider;
  id: string;

  constructor(type: ContentType, provider: Provider | undefined, id: string) {
    this.type = type;
    this.provider = provider;
    this.id = id;
  }

  static fromString(id: string): ContentID {
    const [type, providerOrId, maybeId] = id.split(':');
    let parsedType: ContentType;
    switch (type) {
      case ContentType.Movie:
        parsedType = ContentType.Movie;
        break;
      case ContentType.TvShow:
        parsedType = ContentType.TvShow;
        break;
      default:
        throw new Error(`Invalid type ${type}`);
    }

    let parsedProvider: Provider | undefined;
    switch (providerOrId) {
      case 'TMDB':
        parsedProvider = Provider.TMDB;
        break;
      case 'CUT':
        parsedProvider = Provider.CUT;
        break;
      default:
        break;
    }

    const parsedId = maybeId || providerOrId;
    return new ContentID(parsedType, parsedProvider, parsedId);
  }

  toString(): string {
    if (this.provider === Provider.TMDB) {
      return `${this.type}:${this.provider}:${this.id}`
    }
    return `${this.type}:${this.id}`
  }

  dbContentType(): DbContentType {
    switch (this.type) {
      case ContentType.Movie:
        return DbContentType.MOVIE;
      case ContentType.TvShow:
        return DbContentType.TV_SHOW;
    }
  }

  async tmdbId(): Promise<string> {
    if (this.provider === Provider.TMDB) {
      return this.id;
    }
    const content = await prisma.movie.findUnique({
      where: {
        id: this.id
      }
    });
    if (!content) {
      throw new Error(`Content with id ${this.id} not found`);
    }
    if (!content.tmdbId) {
      throw new Error(`Content with id ${this.id} has no tmdbId`);
    }
    return content.tmdbId.toString();
  }
}
