
import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import ContentID from '../../types/ContentID';
import Provider from '../../types/providers';
import { RatingCacheKey } from './ratingCacheKey';

// TODO - this is a dupe of watchListDataLoader, refactor to one file
export default class AnnonymousRatingDataLoader {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  private batchRatings = new DataLoader<RatingCacheKey, number | null>(async (ids) => {
    const result = await this.prisma.annonymousRating.findMany(
      {
        where: {
          OR: ids.map((id) => {
            const contentId = ContentID.fromString(id.contentId);
            let movieWhere: Prisma.AnnonymousRatingWhereInput = {
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
    let contentById = new Map(result.map((r) => [r.contentId, r.rating]));
    let contentByTmdbId = new Map(result.map((r) => [r.content.tmdbId, r.rating]));
    return ids.map((id) => {
      const contentId = ContentID.fromString(id.contentId);
      return (contentId.provider === Provider.TMDB ? contentByTmdbId.get(parseInt(contentId.id)) : contentById.get(contentId.id)) || null;
    });
  })

  async getRating(key: RatingCacheKey) {
    return this.batchRatings.load(key)
  }
}
