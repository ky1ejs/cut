import { User } from "@prisma/client"

export const profileImageUrl = (user: User) => {
  let imageUrl: string | null = null
  if (user.imageId) {
    imageUrl = `https://ucarecdn.com/${user.imageId}/-/resize/500x500/-/format/jpeg/profile`
  }
  return imageUrl
}