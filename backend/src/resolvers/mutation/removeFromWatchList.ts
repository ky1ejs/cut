import exp from "constants";
import { MutationRemoveFromWatchListArgs } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";

const removeFromWatchList = async (context: GraphQLContext, args: MutationRemoveFromWatchListArgs) => {
  if (!context.user) {
    throw new Error('Unauthorized');
  }

  const [provider, movieId] = args.movieId.split(':');
  if (provider !== 'CUT') {
    throw new Error('Provider not supported');
  }

  return prisma.watchList.delete({
    where: {
      movieId_userId: {
        movieId: movieId,
        userId: context.user.id
      }
    }
  }
  ).then(() => true);
}

export default removeFromWatchList;
