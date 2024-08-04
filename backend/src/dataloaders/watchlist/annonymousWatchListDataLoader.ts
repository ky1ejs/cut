
import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import ContentID from '../../types/ContentID';
import Provider from '../../types/providers';
import { WatchListCacheKey } from './watchListCacheKey';

// TODO - this is a dupe of watchListDataLoader, refactor to one file
export default class AnnonymousWatchListDataLoader {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchWatchList = new DataLoader<WatchListCacheKey, boolean>(async (ids) => {
    const result = await this.prisma.annonymousWatchList.findMany(
      {
        where: {
          OR: ids.map((id) => {
            const contentId = ContentID.fromString(id.contentId);
            let contentWhere: Prisma.AnnonymousWatchListWhereInput = {
              userId: id.userId,
            };
            switch (contentId.provider) {
              case Provider.TMDB:
                contentWhere = {
                  ...contentWhere,
                  content: {
                    tmdbId: parseInt(contentId.id)
                  }
                };
                break;
              default:
                contentWhere = {
                  ...contentWhere,
                  contentId: contentId.id
                }
                break;
            }
            return contentWhere;
          }),
        },
        include: {
          content: true
        }
      }
    )
    let contentIds = result.map((r) => r.contentId);
    let tmdbIds = result.map((r) => r.content.tmdbId);
    return ids.map((id) => {
      const contentId = ContentID.fromString(id.contentId);
      return contentId.provider === Provider.TMDB ? tmdbIds.includes(parseInt(contentId.id)) : contentIds.includes(contentId.id);
    });
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
