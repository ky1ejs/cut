import { GraphQLError } from "graphql";
import { MutationResolvers, ContentType as GqlContentType } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { ContentType, Prisma } from "@prisma/client";
import { hash } from "../../services/bcrypt";
import processPhoneNumber from "../../services/phoneNumberProcessing";
import Provider from "../../types/providers";
import importTmbdMovie from "../../db/tmdbImporter";
import TMDB from "../../datasources/TMDB";
import ContentID from "../../types/ContentID";
import dbUserToGqlUser from "../mappers/dbUserToGqlUser";

const updateAccount: MutationResolvers["updateAccount"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  const params = args.params
  let update: Prisma.UserUpdateInput = {}

  if (params.username) {
    update.username = params.username
  }

  if (params.name) {
    update.name = params.name
  }

  if (params.bio !== undefined) {
    update.bio = params.bio
  }

  if (params.phoneNumber !== undefined) {
    if (params.phoneNumber === null) {
      update.phoneNumber = null
      update.countryCode = null
      update.hashedPhoneNumber = null
    } else {
      const processedPhoneNumber = await processPhoneNumber(params.phoneNumber)
      update.phoneNumber = processedPhoneNumber.phoneNumber
      update.countryCode = processedPhoneNumber.code
      update.hashedPhoneNumber = processedPhoneNumber.hashedPhoneNumber
    }
  }

  if (params.url !== undefined) {
    update.url = params.url
  }

  if (params.favoriteMovies !== undefined) {
    if (params.favoriteMovies === null) {
      update.favoriteMovies = []
    } else {
      const ids = params.favoriteMovies
        .map(m => ContentID.fromString(m))
        .map(m => importFavoriteMovie(m, context.dataSources.tmdb))
      update.favoriteMovies = await Promise.all(ids)
    }
  }

  const updatedUser = await prisma.user.update({
    where: { id: context.userDevice.userId },
    data: update
  })

  context.userDevice.user = updatedUser

  return dbUserToGqlUser(updatedUser)
}

async function importFavoriteMovie(contentId: ContentID, tmdb: TMDB): Promise<string> {
  if (contentId.provider === Provider.TMDB) {
    const existingMovie = await prisma.movie.findUnique({
      where: {
        tmdbId: parseInt(contentId.id)
      }
    })
    if (existingMovie) {
      return existingMovie.id
    } else {
      let content: any
      if (contentId.type === GqlContentType.Movie) {
        content = await tmdb.fetchMovie(contentId.id)
      } else {
        content = await tmdb.fetchTvShow(contentId.id)
      }
      return (await importTmbdMovie(content, "en", "US", contentId.dbContentType())).id
    }
  } else {
    return contentId.id
  }
}

export default updateAccount;