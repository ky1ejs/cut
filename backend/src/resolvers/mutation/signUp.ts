import { Device, MutationSignUpArgs } from "../../__generated__/graphql";
import prisma from "../../prisma";

const signUp = async (args: MutationSignUpArgs): Promise<Device> => {
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

export default signUp;
