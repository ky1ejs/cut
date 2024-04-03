
import DataLoader from "dataloader";
import prisma from "../prisma";
import { User } from "@prisma/client";

export default class UserDataLoader {
  private batchUserFetch = new DataLoader<string, User>(async (ids) => {
    const users = await prisma.user.findMany({
      where: {
        OR: ids.map((id) => ({ id }))
      }
    })
    const keyedMovies = new Map(users.map(m => [m.id, m]))
    return ids.map(id => {
      const u = keyedMovies.get(id)
      if (!u) {
        throw new Error(`User ${id} not found`)
      }
      return u
    })
  })

  async getUser(id: string) {
    return this.batchUserFetch.load(id)
  }
}
