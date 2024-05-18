import { User } from "@prisma/client";
import { CompleteAccount } from "../../__generated__/graphql";
import { DeepPartial } from "utility-types";
import { profileImageUrl } from "./cdnUrls";

export default function dbUserToGqlUser(user: User): DeepPartial<CompleteAccount> {
  return {
    ...user,
    favoriteMovies: undefined,
    share_url: `https://cut.watch/p/${user.username}`,
    phoneNumber: user.phoneNumber ? `${user.countryCode}${user.phoneNumber}` : null,
    imageUrl: profileImageUrl(user)
  }
}
