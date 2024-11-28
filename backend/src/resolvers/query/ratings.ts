import { Content } from "@prisma/client";
import { GraphQLError, GraphQLResolveInfo } from "graphql";
import { DeepPartial } from "utility-types";
import { QueryResolvers, IncompleteAccountResolvers, ProfileInterface, ContentRating } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import contentDbToGqlMapper, { contentInclude } from "../mappers/contentDbToGqlMapper";

enum UserType {
  ANNONYMOUS,
  KNOWN
}

export const currentUserRatings: QueryResolvers["ratings"] = async (_, __, context) => {
  let r: DeepPartial<ContentRating>[] = [];
  if (context.userDevice) {
    r = await ratings(context.userDevice.userId, UserType.KNOWN);
  } else if (context.annonymousUserDevice) {
    r = await ratings(context.annonymousUserDevice.userId, UserType.ANNONYMOUS);
  } else {
    throw new GraphQLError("User not authenticated");
  }
  return r.map((rating) => ({
    ...rating.content,
    rating: rating.rating
  }));
}

export const annonymousUsersRatings: IncompleteAccountResolvers["ratings"] = async (_, __, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("User not authenticated");
  }
  const r = await ratings(context.annonymousUserDevice.userId, UserType.ANNONYMOUS);
  return r.map((rating) => ({
    ...rating.content,
    rating: rating.rating
  }))
}

export async function completeAccountRatings(parent: DeepPartial<ProfileInterface>, context: GraphQLContext, info: GraphQLResolveInfo): Promise<DeepPartial<ContentRating>[]> {
  if (info.path.prev?.key === "account" || info.path.prev?.key === undefined) {
    if (context.userDevice) {
      return ratings(context.userDevice.userId, UserType.KNOWN);
    } else {
      throw new GraphQLError("User not authenticated");
    }
  } else if (parent.id) {
    return ratings(parent.id, UserType.KNOWN);
  } else if (info.variableValues.id && typeof info.variableValues.id === "string") {
    return ratings(info.variableValues.id, UserType.KNOWN);
  } else if (info.variableValues.username && typeof info.variableValues.username === "string") {
    const user = await prisma.user.findUnique({
      where: { username: info.variableValues.username }
    });
    if (user) {
      return ratings(user.id, UserType.KNOWN);
    } else {
      throw new GraphQLError("User not found");
    }
  }
  throw new GraphQLError("Bad request");
}

export default async function ratings(userId: string, type: UserType): Promise<DeepPartial<ContentRating>[]> {
  const include = { content: { include: contentInclude } }

  switch (type) {
    case UserType.KNOWN:
      return prisma.rating.findMany({
        where: { userId },
        include
      }).then((ratings) => ratings.map((rating) => ({
        ...contentDbToGqlMapper(rating.content),
        rating: rating.rating
      })));
    case UserType.ANNONYMOUS:
      return prisma.annonymousRating.findMany({
        where: { userId },
        include
      }).then((ratings) => ratings.map((rating) => ({
        ...contentDbToGqlMapper(rating.content),
        rating: rating.rating
      })));
  }
}
