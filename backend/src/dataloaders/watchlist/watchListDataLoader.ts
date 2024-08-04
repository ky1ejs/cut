import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import ContentID from '../../types/ContentID';
import Provider from '../../types/providers';
import { WatchListCacheKey } from './watchListCacheKey';

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
            const contentId = ContentID.fromString(id.contentId);
            let movieWhere: Prisma.WatchListWhereInput = {
              userId: id.userId,
            };
            switch (contentId.provider) {
              case Provider.TMDB:
                movieWhere = {
                  ...movieWhere,
                  content: {
                    tmdbId: parseInt(contentId.id)
                  }
                };
                break;
              default:
                movieWhere = {
                  ...movieWhere,
                  contentId: contentId.id
                }
                break;
            }
            return movieWhere;
          }),
        },
        include: {
          content: true
        }
      }
    )
    let movieIds = result.map((r) => r.contentId);
    let tmdbIds = result.map((r) => r.content.tmdbId);
    return ids.map((id) => {
      const contentId = ContentID.fromString(id.contentId);
      return contentId.provider === Provider.TMDB ? tmdbIds.includes(parseInt(contentId.id)) : movieIds.includes(contentId.id);
    });
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
