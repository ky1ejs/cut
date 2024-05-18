import { User } from "@prisma/client";
import { Profile, ProfileInterface } from "../../__generated__/graphql";
import { DeepPartial } from "utility-types";
import { profileImageUrl } from "./cdnUrls";

export function mapProfileInterface(user: User, isCurrentUser: boolean): DeepPartial<ProfileInterface> {
  return {
    id: user.id,
    username: user.username,
    name: user.name,
    bio_url: user.url,
    bio: user.bio,
    share_url: "https://cut.watch/p/" + user.username,
    followerCount: user.followerCount,
    followingCount: user.followingCount,
    imageUrl: profileImageUrl(user),
    isCurrentUser
  }
}

export function mapProfile(user: User, isFollowing: boolean | undefined, isCurrentUser: boolean | undefined): DeepPartial<Profile> {

  let result: DeepPartial<Profile> = mapProfileInterface(user, isCurrentUser || false);
  if (isFollowing !== undefined) {
    result.isFollowing = isFollowing
  }
  return result
}
