import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import ContentID from '../../types/ContentID';
import Provider from '../../types/providers';
import { RatingCacheKey } from './ratingCacheKey';

export default class RatingDataLoader {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchRatings = new DataLoader<RatingCacheKey, number | null>(async (ids) => {
    const result = await this.prisma.rating.findMany(
      {
        where: {
          OR: ids.map((id) => {
            const contentId = ContentID.fromString(id.contentId);
            let contentWhere: Prisma.RatingWhereInput = {
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
    let moviesById = new Map(result.map((r) => [r.contentId, r.rating]));
    let moviesByTmdbId = new Map(result.map((r) => [r.content.tmdbId, r.rating]));
    return ids.map((id) => {
      const contentId = ContentID.fromString(id.contentId);
      return (contentId.provider === Provider.TMDB ? moviesByTmdbId.get(parseInt(contentId.id)) : moviesById.get(contentId.id)) || null;
    });
  })

  async getRating(key: RatingCacheKey) {
    return this.batchRatings.load(key)
  }
}
