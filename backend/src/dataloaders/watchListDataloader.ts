import { PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';

export type WatchListCacheKey = {
  tmdbId: number;
  userId: string;
};

export default class WatchListDataSource {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchWatchList = new DataLoader<WatchListCacheKey, boolean>(async (ids) => {
    console.log('Fetching watchlist status for', ids);
    const result = await this.prisma.watchList.findMany(
      {
        where: {
          OR: ids.map((id) => ({
            userId: id.userId,
            tmdbId: id.tmdbId,
          })),
        }
      }
    )
    console.log('Fetched watchlist status for', result);
    // Dataloader expects you to return a list with the results ordered just like the list in the arguments were
    // Since the database might return the results in a different order the following code sorts the results accordingly
    const presentKeys = result.map((w) => `${w.userId}:${w.movieId}`);
    return ids.map((id) => presentKeys.includes(`${id.userId}:${id.tmdbId}`));
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
