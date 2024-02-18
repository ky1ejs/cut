import exp from "constants";
import { MutationRemoveFromWatchListArgs } from "../../__generated__/graphql";
import { GraphQLContext } from "../../boot";
import prisma from "../../prisma";

const removeFromWatchList = async (context: GraphQLContext, args: MutationRemoveFromWatchListArgs) => {
  if (!context.user) {
    throw new Error('Unauthorized');
  }
  return prisma.watchList.delete({
    where: {
      movieId_userId: {
        movieId: args.movieId,
        userId: context.user.id
      }
    }
  }
  ).then(() => true);
}

export default removeFromWatchList;
