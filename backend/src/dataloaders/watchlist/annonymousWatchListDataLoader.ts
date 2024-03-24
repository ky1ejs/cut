
import { Prisma, PrismaClient } from '@prisma/client';
import DataLoader from 'dataloader';
import { WatchListCacheKey } from './watchListDataLoader';

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
            // fix this by putting the IDs for providers in the same row?
            const [provider, movieId] = id.movieId.split(':');
            let movieWhere: Prisma.AnnonymousWatchListWhereInput = {
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
              default:
                movieWhere = {
                  ...movieWhere,
                  movieId: movieId
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
      const [provider, movieId] = id.movieId.split(':');
      const parsedMovieId = movieId || provider;
      return provider === 'TMDB' ? tmdbIds.includes(parseInt(parsedMovieId)) : movieIds.includes(parsedMovieId);
    });
  })

  async getWatchlistStatusFor(key: WatchListCacheKey) {
    return this.batchWatchList.load(key)
  }
}
