import { MutationAddToWatchListArgs } from "../../__generated__/graphql";
import { GraphQLContext } from "../../boot";
import prisma from "../../prisma";

export default async function addToWatchList(context: GraphQLContext, args: MutationAddToWatchListArgs) {
  if (!context.user) {
    throw new Error('Unauthorized');
  }

  await prisma.watchList.upsert({
    where: { movieId_userId: { movieId: args.movieId, userId: context.user.id } },
    create: { userId: context.user.id, movieId: args.movieId },
    update: {}
  });

  return true
}
