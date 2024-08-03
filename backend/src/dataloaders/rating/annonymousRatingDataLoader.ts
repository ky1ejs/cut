
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
            const contentId = ContentID.fromString(id.movieId);
            let movieWhere: Prisma.AnnonymousRatingWhereInput = {
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
    let moviesById = new Map(result.map((r) => [r.movieId, r.rating]));
    let moviesByTmdbId = new Map(result.map((r) => [r.movie.tmdbId, r.rating]));
    return ids.map((id) => {
      const contentId = ContentID.fromString(id.movieId);
      return (contentId.provider === Provider.TMDB ? moviesByTmdbId.get(parseInt(contentId.id)) : moviesById.get(contentId.id)) || null;
    });
  })

  async getRating(key: RatingCacheKey) {
    return this.batchRatings.load(key)
  }
}
