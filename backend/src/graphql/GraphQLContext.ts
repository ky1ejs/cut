import { User } from "@prisma/client"
import WatchListDataSource from "../dataloaders/watchListDataloader"

export interface GraphQLContext {
  user?: User
  dataSources: {
    watchList: WatchListDataSource
  }
}
