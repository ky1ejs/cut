import { GraphQLError } from "graphql";
import { ProfileInterfaceResolvers } from "../../__generated__/graphql";
import contentDbToGqlMapper from "../mappers/contentDbToGqlMapper";
import { User } from "@prisma/client";
import { compact } from "lodash";

const favoriteContent: ProfileInterfaceResolvers["favoriteContent"] = async (parent, _, context) => {
  if (!parent.id) {
    throw new GraphQLError("Missing data")
  }

  let user: User
  if (parent.id === context.userDevice?.userId) {
    user = context.userDevice.user
  } else {
    user = await context.dataSources.users.getUser(parent.id)
  }

  const ids = user.favoriteContentIds.slice(0, 5)
  const content = await Promise.all(ids.map(id => context.dataSources.content.getContent(id)))
  const mappedContent = content.map(m => {
    if (!m) {
      return undefined
    }
    return contentDbToGqlMapper(m)
  })
  return compact(mappedContent)
}

export default favoriteContent;
