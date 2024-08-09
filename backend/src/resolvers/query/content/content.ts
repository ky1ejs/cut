import { ContentType, ExtendedContentResponse, ExtendedContentUnion, QueryResolvers } from "../../../__generated__/graphql";
import movieResolver from "./movie";
import tvShowResolver from "./tvshow";
import { DeepPartial } from "utility-types";
import ContentID from "../../../types/ContentID";
import TMDB from "../../../datasources/TMDB";

const contentResolver: QueryResolvers["content"] = async (_, args, context) => {
  return getContent(args.id, context.dataSources.tmdb);
}

export async function getContent(id: string, tmdb: TMDB): Promise<DeepPartial<ExtendedContentResponse>> {
  const contentId = ContentID.fromString(id);
  let contentResult: DeepPartial<ExtendedContentUnion>
  switch (contentId.type) {
    case ContentType.Movie:
      contentResult = await movieResolver(contentId, tmdb);
      break;
    case ContentType.TvShow:
      contentResult = await tvShowResolver(contentId, tmdb);
      break;
    default:
      throw new Error(`Content with id ${id} not found`);
  }
  return {
    result: contentResult,
    type: contentResult.type
  }
}

export default contentResolver;
