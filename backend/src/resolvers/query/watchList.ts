import { IncompleteAccountResolvers, Content, ProfileInterface, QueryResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { GraphQLError, GraphQLResolveInfo } from "graphql";
import contentDbToGqlMapper, { contentInclude } from "../mappers/contentDbToGqlMapper";
import { DeepPartial } from "utility-types";

enum UserType {
  ANNONYMOUS,
  KNOWN
}

export const currentUserWatchList: QueryResolvers["watchList"] = (_, __, context) => {
  if (context.userDevice) {
    return watchList(context.userDevice.userId, UserType.KNOWN);
  } else if (context.annonymousUserDevice) {
    return watchList(context.annonymousUserDevice.userId, UserType.ANNONYMOUS);
  }
  throw new GraphQLError("User not authenticated");
}

export const incompleteAccountWatchList: IncompleteAccountResolvers["watchList"] = (_, __, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("User not authenticated");
  }
  return watchList(context.annonymousUserDevice.userId, UserType.ANNONYMOUS);
}

export async function completeAccountWatchList(parent: DeepPartial<ProfileInterface>, context: GraphQLContext, info: GraphQLResolveInfo): Promise<DeepPartial<Content>[]> {
  if (info.path.prev?.key === "account" || info.path.prev?.key === undefined) {
    if (context.userDevice) {
      return watchList(context.userDevice.userId, UserType.KNOWN);
    } else {
      throw new GraphQLError("User not authenticated");
    }
  } else if (parent.id) {
    return watchList(parent.id, UserType.KNOWN);
  } else if (info.variableValues.id && typeof info.variableValues.id === "string") {
    return watchList(info.variableValues.id, UserType.KNOWN);
  } else if (info.variableValues.username && typeof info.variableValues.username === "string") {
    const user = await prisma.user.findUnique({
      where: { username: info.variableValues.username }
    });
    if (user) {
      return watchList(user.id, UserType.KNOWN);
    } else {
      throw new GraphQLError("User not found");
    }
  }
  throw new GraphQLError("Bad request");
}

export default async function watchList(userId: string, type: UserType) {
  const include = { content: { include: contentInclude } }

  switch (type) {
    case UserType.KNOWN:
      return prisma.watchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => ({
        ...contentDbToGqlMapper(watchListItem.content),
        isOnWatchList: true
      })));
    case UserType.ANNONYMOUS:
      return prisma.annonymousWatchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => ({
        ...contentDbToGqlMapper(watchListItem.content),
        isOnWatchList: true
      })));
  }
}
