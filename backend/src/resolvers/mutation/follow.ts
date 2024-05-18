import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { sendIosPush } from "../../services/sendIosPush";
import { mapProfile } from "../mappers/profileMapper";

const follow: MutationResolvers["follow"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  const data = {
    followerId: context.userDevice.user.id,
    followingId: args.userId
  }

  const result = await prisma.follow.upsert(
    {
      where: {
        followerId_followingId: data
      },
      create: data,
      update: {},
      include: {
        following: true,
      }
    }
  )

  const notificationKey = `follow:${context.userDevice.user.id}:${args.userId}`
  const latestPush = await prisma.sentNotification.findFirst({
    where: {
      idempotencyKey: notificationKey,
      userId: context.userDevice.user.id
    },
    orderBy: {
      createdAt: "desc"
    }
  })

  if (!latestPush?.repeatLimit || latestPush.repeatLimit > (Date.now() - latestPush.createdAt.getTime())) {
    const devices = await prisma.device.findMany({
      where: {
        userId: args.userId
      },
      include: {
        token: true
      }
    })
    const title = "New Follower"
    const body = `${context.userDevice.user.username} followed you!`
    for (const device of devices) {
      if (!device.token) continue
      await sendIosPush(
        device.token,
        {
          title,
          body
        })
    }
    await prisma.sentNotification.create({
      data: {
        idempotencyKey: notificationKey,
        repeatLimit: 60 * 60, // once every hour
        userId: context.userDevice.user.id,
        title,
        body
      }
    })
  }

  return mapProfile(result.following, true, false)
}

export default follow;
