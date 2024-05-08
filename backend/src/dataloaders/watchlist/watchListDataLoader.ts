import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import ContentID from '../../types/ContentID';
import Provider from '../../types/providers';

export type WatchListCacheKey = {
  movieId: string;
  userId: string;
};

export default class WatchListDataLoader {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchWatchList = new DataLoader<WatchListCacheKey, boolean>(async (ids) => {
    const result = await this.prisma.watchList.findMany(
      {
        where: {
          OR: ids.map((id) => {
            const contentId = ContentID.fromString(id.movieId);
            let movieWhere: Prisma.WatchListWhereInput = {
              userId: id.userId,
            };
            switch (contentId.provider) {
              case Provider.TMDB:
                movieWhere = {
                  ...movieWhere,
                  movie: {
                    tmdbId: parseInt(contentId.id)
                  }
                };
                break;
              default:
                movieWhere = {
                  ...movieWhere,
                  movieId: contentId.id
                }
                break;
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
      const contentId = ContentID.fromString(id.movieId);
      return contentId.provider === Provider.TMDB ? tmdbIds.includes(parseInt(contentId.id)) : movieIds.includes(contentId.id);
    });
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
