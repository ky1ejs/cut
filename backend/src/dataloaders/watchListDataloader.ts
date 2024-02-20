import { Prisma, PrismaClient } from '@prisma/client';
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
            // fix this by putting the IDs for providers in the same row?
            const [provider, movieId] = id.movieId.split(':');
            console.log('provider', provider);
            console.log('movieId', movieId);
            let movieWhere: Prisma.WatchListWhereInput = {
              userId: id.userId,
            };
            switch (provider) {
              case 'TMDB':
                movieWhere = {
                  ...movieWhere,
                  movie: {
                    tmdbId: parseInt(movieId)
                  }
                };
                break;
              case 'CUT':
                movieWhere = {
                  ...movieWhere,
                  movieId: movieId
                }
                break;
              default:
                throw new Error('Provider not supported');
            }
            return movieWhere;
          }),
        },
        include: {
          movie: true
        }
      }
    )
    let movieIds = result.map((r) => r.movieId);
    let tmdbIds = result.map((r) => r.movie.tmdbId);
    return ids.map((id) => {
      const [provider, movieId] = id.movieId.split(':');
      return provider === 'TMDB' ? tmdbIds.includes(parseInt(movieId)) : movieIds.includes(movieId);
    });
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
