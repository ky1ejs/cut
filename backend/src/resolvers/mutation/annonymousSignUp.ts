import { Device, MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const annonymousSignUp: MutationResolvers["annonymousSignUp"] = async (_, args): Promise<Device> => {
  const device = await prisma.annonymousDevice.create({
    data: {
      name: args.deviceName,
      user: {
        create: {}
      }
    },
  })
  return {
    name: device.name,
    session_id: device.sessionId
  }
}

export default annonymousSignUp;
