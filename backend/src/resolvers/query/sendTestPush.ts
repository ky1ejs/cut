import { GraphQLError } from "graphql";
import { Query, QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { sendIosPush } from "../../services/sendIosPush";

const sendTestPush: QueryResolvers["sendTestPush"] = async (_, __, context) => {
  if (context.annonymousUserDevice) {
    const token = await prisma.annoymousPushToken.findUnique({
      where: {
        device_id: context.annonymousUserDevice.id
      }
    })
    if (!token) return false
    await sendIosPush(
      token,
      {
        title: "Testing 123",
        body: "This is a test push"
      }
    )
  } else if (context.userDevice) {
    const token = await prisma.pushToken.findUnique({
      where: {
        device_id: context.userDevice.id
      }
    })
    if (!token) return false
    await sendIosPush(
      token,
      {
        title: "Testing 123",
        body: "This is a test push"
      }
    )
  } else {
    throw new GraphQLError("Unauthorized")
  }
  return true
}

export default sendTestPush;
