import { PrismaClient, Provider } from '@prisma/client';
import DataLoader from 'dataloader';

export type WatchListCacheKey = {
  movieId: string;
  userId: string;
};

export default class WatchListDataSource {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchWatchList = new DataLoader<WatchListCacheKey, boolean>(async (ids) => {
    const result = await this.prisma.watchList.findMany(
      {
        where: {
          OR: ids.map((id) => {
            const [provider, movieId] = id.movieId.split(':');
            console.log('provider', provider);
            console.log('movieId', movieId);
            switch (provider) {
              case 'TMDB':
                return {
                  userId: id.userId,
                  movie: {
                    providers: {
                      some: {
                        provider: Provider.TMDB,
                        externalId: movieId
                      }
                    }
                  }
                };
              case 'CUT':
                return {
                  userId: id.userId,
                  movieId: movieId
                }
              default:
                throw new Error('Provider not supported');
            }
          }),
        }
      }
    )
    const presentKeys = result.map((w) => `${w.userId}:${w.movieId}`);
    return ids.map((id) => presentKeys.includes(`${id.userId}:${id.movieId}`));
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
