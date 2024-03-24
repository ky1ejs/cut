import DataLoader from "dataloader";
import prisma from "../prisma";

interface FollowingCacheKey {
  userId: string;
  followingId: string; // person they may be following
}

export default class AnnonymousWatchListDataLoader {
  private batchWatchList = new DataLoader<FollowingCacheKey, boolean>(async (ids) => {
    return prisma.follow.findMany({
      where: {
        OR: ids.map((id) => ({
          followerId: id.userId,
          followingId: id.followingId,
        }))
      }
    })
      .then((follows) => {
        const followMap = new Map(follows.map((follow) => [`${follow.followerId}:${follow.followingId}`, true]))
        return ids.map((id) => followMap.get(`${id.userId}:${id.followingId}`) || false)
      })
  })

  async getFollowingFor(key: FollowingCacheKey) {
    return this.batchWatchList.load(key)
  }
}
