import { ProfileInterfaceResolvers, ProfileResolvers } from "../../__generated__/graphql";

const isFollowing: ProfileResolvers["isFollowing"] = async (profile, _, context) => {
  if (!context.userDevice) {
    return false
  }
  if (!profile.id) {
    throw new Error("Profile id is required")
  }
  return await context.dataSources.isFollowing.getFollowingFor({ userId: context.userDevice.userId, followingId: profile.id })
}

export default isFollowing;