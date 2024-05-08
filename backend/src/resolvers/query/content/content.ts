import { ContentType, ContentUnion, QueryResolvers } from "../../../__generated__/graphql";
import movieResolver from "./movie";
import tvShowResolver from "./tvshow";
import { DeepPartial } from "utility-types";
import ContentID from "../../../types/ContentID";

const contentResolver: QueryResolvers["content"] = async (_, args, context) => {
  const contentId = ContentID.fromString(args.id);
  let contentResult: DeepPartial<ContentUnion>
  switch (contentId.type) {
    case ContentType.Movie:
      contentResult = await movieResolver(contentId, context.dataSources.tmdb);
      break;
    case ContentType.TvShow:
      contentResult = await tvShowResolver(contentId, context.dataSources.tmdb);
      break;
    default:
      throw new Error(`Content with id ${args.id} not found`);
  }
  return {
    result: contentResult,
    type: contentResult.type
  }
}

export default contentResolver;
