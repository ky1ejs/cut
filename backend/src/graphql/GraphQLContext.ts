import { AnnonymousDevice, AnonymousUser, Device, User } from "@prisma/client"
import WatchListDataLoader from "../dataloaders/watchlist/watchListDataLoader"
import AnnonymousWatchListDataLoader from "../dataloaders/watchlist/annonymousWatchListDataLoader"
import IsFollowingDataLoader from "../dataloaders/isFollowingDataLoader"
import MovieDataLoader from "../dataloaders/MovieDataLoader"
import UserDataLoader from "../dataloaders/UserDataLoader"

export interface GraphQLContext {
  annonymousUserDevice?: AnnonymousDevice & { user: AnonymousUser }
  userDevice?: Device & { user: User }
  dataSources: {
    watchList: WatchListDataLoader
    annonymousWatchList: AnnonymousWatchListDataLoader,
    isFollowing: IsFollowingDataLoader,
    movies: MovieDataLoader,
    users: UserDataLoader
  }
}
