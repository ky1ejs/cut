import { ContentType } from "@prisma/client";
import { ContentType as GqlContentType } from "../../__generated__/graphql";

export default function dbContentTypeToGqlContentType(contentType: ContentType): GqlContentType {
  switch (contentType) {
    case ContentType.MOVIE:
      return GqlContentType.Movie;
    case ContentType.TV_SHOW:
      return GqlContentType.TvShow;
    default:
      throw new Error(`Content type ${contentType} not supported`);
  }
}
