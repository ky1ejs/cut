import { $Enums } from "@prisma/client";
import { MutationResolvers, TokenEnv as GraphQLTokenEnv, PushPlatform as GraphQLPushPlatform } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";

const setPushToken: MutationResolvers["setPushToken"] = async (_, args, context) => {
  let env: $Enums.TokenEnv
  switch (args.token.env) {
    case GraphQLTokenEnv.Production:
      env = $Enums.TokenEnv.PRODUCTION
      break
    case GraphQLTokenEnv.Staging:
      env = $Enums.TokenEnv.STAGING
      break
    default:
      throw new GraphQLError("Invalid env")
  }

  let platform: $Enums.PushPlatform
  switch (args.token.platform) {
    case GraphQLPushPlatform.Android:
      platform = $Enums.PushPlatform.ANDROID
      break
    case GraphQLPushPlatform.Ios:
      platform = $Enums.PushPlatform.IOS
      break
    case GraphQLPushPlatform.Web:
      platform = $Enums.PushPlatform.WEB
      break
    default:
      throw new GraphQLError("Invalid platform")
  }

  if (context.userDevice) {
    const update = {
      token: args.token.token,
      env,
      platform,
    }

    await prisma.pushToken.upsert(
      {
        where: {
          device_id: context.userDevice.id
        },
        create: {
          ...update,
          device_id: context.userDevice.id
        },
        update
      }
    )
  } else if (context.annonymousUserDevice) {
    const update = {
      token: args.token.token,
      env,
      platform,
    }

    await prisma.annoymousPushToken.upsert(
      {
        where: {
          device_id: context.annonymousUserDevice.id
        },
        create: {
          ...update,
          device_id: context.annonymousUserDevice.id
        },
        update
      }
    )
  } else {
    throw new GraphQLError("Unauthorized")
  }

  return true
}

export default setPushToken;
