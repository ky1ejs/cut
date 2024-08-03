import { AnnonymousDevice, AnonymousUser, Device, User } from "@prisma/client"
import WatchListDataLoader from "../dataloaders/watchlist/watchListDataLoader"
import AnnonymousWatchListDataLoader from "../dataloaders/watchlist/annonymousWatchListDataLoader"
import IsFollowingDataLoader from "../dataloaders/isFollowingDataLoader"
import MovieDataLoader from "../dataloaders/MovieDataLoader"
import UserDataLoader from "../dataloaders/UserDataLoader"
import TMDB from "../datasources/TMDB"
import AnnonymousRatingDataLoader from "../dataloaders/rating/annonymousRatingDataLoader"
import RatingDataLoader from "../dataloaders/rating/ratingDataLoader"

export interface GraphQLContext {
  annonymousUserDevice?: AnnonymousDevice & { user: AnonymousUser }
  userDevice?: Device & { user: User }
  dataSources: {
    watchList: WatchListDataLoader
    annonymousWatchList: AnnonymousWatchListDataLoader,
    ratingDataLoader: RatingDataLoader,
    annonymousRatingDataLoader: AnnonymousRatingDataLoader,
    isFollowing: IsFollowingDataLoader,
    movies: MovieDataLoader,
    users: UserDataLoader,
    tmdb: TMDB
  }
}
