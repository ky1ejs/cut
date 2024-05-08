import { User } from "@prisma/client";
import { Profile, ProfileInterface } from "../../__generated__/graphql";
import { DeepPartial } from "utility-types";

export function mapProfileInterface(user: User): DeepPartial<ProfileInterface> {
  let result: DeepPartial<ProfileInterface> = {
    id: user.id,
    username: user.username,
    name: user.name,
    bio_url: user.url,
    bio: user.bio,
    share_url: "https://cut.watch/p/" + user.username,
    followerCount: user.followerCount,
    followingCount: user.followingCount,
  }
  return result
}

export function mapProfile(user: User, isFollowing: boolean | undefined): DeepPartial<Profile> {
  let result: DeepPartial<Profile> = mapProfileInterface(user);
  if (isFollowing !== undefined) {
    result.isFollowing = isFollowing
  }
  return result
}
