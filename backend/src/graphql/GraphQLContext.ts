import { AnnonymousDevice, AnonymousUser, Device, User } from "@prisma/client"
import WatchListDataLoader from "../dataloaders/watchListDataLoader"
import AnnonymousWatchListDataLoader from "../dataloaders/annonymousWatchListDataLoader"

export interface GraphQLContext {
  annonymousUserDevice?: AnnonymousDevice & { user: AnonymousUser }
  userDevice?: Device & { user: User }
  dataSources: {
    watchList: WatchListDataLoader
    annonymousWatchList: AnnonymousWatchListDataLoader
  }
}
