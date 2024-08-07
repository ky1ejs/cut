import { IncompleteAccountResolvers, Content, ProfileInterface, QueryResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { GraphQLError, GraphQLResolveInfo } from "graphql";
import contentDbToGqlMapper, { contentInclude } from "../mappers/contentDbToGqlMapper";
import { DeepPartial } from "utility-types";

enum UserType {
  INCOMPLETE,
  COMPLETE
}

export const unknownAccountWatchList: QueryResolvers["watchList"] = (_, __, context) => {
  if (context.userDevice) {
    return watchList(context.userDevice.userId, UserType.COMPLETE);
  } else if (context.annonymousUserDevice) {
    return watchList(context.annonymousUserDevice.userId, UserType.INCOMPLETE);
  }
  throw new GraphQLError("User not authenticated");
}

export const incompleteAccountWatchList: IncompleteAccountResolvers["watchList"] = (_, __, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("User not authenticated");
  }
  return watchList(context.annonymousUserDevice.userId, UserType.INCOMPLETE);
}

export async function completeAccountWatchList(parent: DeepPartial<ProfileInterface>, context: GraphQLContext, info: GraphQLResolveInfo): Promise<DeepPartial<Content>[]> {
  if (info.path.prev?.key === "account" || info.path.prev?.key === undefined) {
    if (context.userDevice) {
      return watchList(context.userDevice.userId, UserType.COMPLETE);
    } else {
      throw new GraphQLError("User not authenticated");
    }
  } else if (parent.id) {
    return watchList(parent.id, UserType.COMPLETE);
  } else if (info.variableValues.id && typeof info.variableValues.id === "string") {
    return watchList(info.variableValues.id, UserType.COMPLETE);
  } else if (info.variableValues.username && typeof info.variableValues.username === "string") {
    const user = await prisma.user.findUnique({
      where: { username: info.variableValues.username }
    });
    if (user) {
      return watchList(user.id, UserType.COMPLETE);
    } else {
      throw new GraphQLError("User not found");
    }
  }
  throw new GraphQLError("Bad request");
}

export default async function watchList(userId: string, type: UserType) {
  const include = { content: { include: contentInclude } }

  switch (type) {
    case UserType.COMPLETE:
      return prisma.watchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => {
        return contentDbToGqlMapper(watchListItem.content);
      }));
    case UserType.INCOMPLETE:
      return prisma.annonymousWatchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => {
        return contentDbToGqlMapper(watchListItem.content);
      }));
  }
}
