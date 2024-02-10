import { Device, MutationSignUpArgs } from "../../__generated__/graphql";
import prisma from "../../prisma";

const signUp = async (args: MutationSignUpArgs): Promise<Device> => {
  const user = await prisma.user.create({ data: {} })
  const device = await prisma.device.create({
    data: {
      name: args.deviceName,
      user: {
        connect: {
          id: user.id
        }
      }
    }
  })
  return {
    name: device.name,
    session_id: device.sessionId
  }
}

export default signUp;
