import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const logOut: MutationResolvers["logOut"] = async (_, __, context) => {
  if (context.userDevice) {
    await prisma.device.delete({
      where: {
        id: context.userDevice.id,
      },
    });
  } else if (context.annonymousUserDevice) {
    await prisma.device.delete({
      where: {
        id: context.annonymousUserDevice.id,
      },
    });
  } else {
    throw new Error("Unauthorized");
  }
  return true
}

export default logOut;
