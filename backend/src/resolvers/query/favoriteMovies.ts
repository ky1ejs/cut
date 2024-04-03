import { GraphQLError } from "graphql";
import { ProfileInterfaceResolvers } from "../../__generated__/graphql";
import dbMovieToGqlMovie from "../mappers/dbMovieToGqlMovie";
import { User } from "@prisma/client";
import { compact } from "lodash";

const favoriteMovies: ProfileInterfaceResolvers["favoriteMovies"] = async (parent, _, context) => {
  if (!parent.id) {
    throw new GraphQLError("Missing data")
  }

  let user: User
  if (parent.id === context.userDevice?.userId) {
    user = context.userDevice.user
  } else {
    user = await context.dataSources.users.getUser(parent.id)
  }

  const ids = user.favoriteMovies.slice(0, 5)
  const movies = await Promise.all(ids.map(id => context.dataSources.movies.getMovie(id)))
  const mappedMovies = movies.map(m => {
    if (!m) {
      return undefined
    }
    return dbMovieToGqlMovie(m)
  })
  return compact(mappedMovies)
}

export default favoriteMovies;
