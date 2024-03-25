import WatchListDataLoader from "../../dataloaders/watchlist/watchListDataLoader"
import { GraphQLContext } from "../../graphql/GraphQLContext"
import prisma from "../../prisma"
import { encrypt } from "../../services/cipher"
import { completeAccount } from "./completeAccount"
import clearDatabase from "../../../tests/clear-database"
import { AnnonymousDevice, AnonymousUser } from "@prisma/client"
import { GraphQLError } from "graphql"
import AnnonymousWatchListDataLoader from "../../dataloaders/watchlist/annonymousWatchListDataLoader"

let device: AnnonymousDevice & { user: AnonymousUser }
let context: GraphQLContext
const email = "test@test.com"

afterEach(async () => {
  await clearDatabase()
})

beforeEach(async () => {
  device = await prisma.annonymousDevice.create({
    include: {
      user: true
    },
    data: {
      name: 'device-name',
      user: {
        create: {}
      }
    }
  })
  context = {
    annonymousUserDevice: device,
    dataSources: {
      watchList: new WatchListDataLoader(prisma),
      annonymousWatchList: new AnnonymousWatchListDataLoader(prisma)
    }
  }
})

describe('completeAccount', () => {
  describe('given a valid token', () => {
    it('should create a user and delete the anonymous user', async () => {
      const token = encrypt(`${email}#${Date.now()}`, process.env.EMAIL_ENCRYPTION_KEY)
      const args = {
        params: {
          username: "username",
          password: "password",
          name: "Jeff",
          emailToken: token
        }
      }
      const result = await completeAccount(args, context)
      expect(result).toEqual({
        completeAccount: {
          // expext ID to be any string
          id: expect.any(String),
          username: 'username',
          name: "Jeff",
          followers: [],
          following: [],
          followingCount: 0,
          followerCount: 0,
          watchList: []
        },
        updatedDevice: {
          name: 'device-name',
          session_id: expect.any(String)
        }
      })
      const userInDb = await prisma.user.findUnique({
        where: {
          username: 'username'
        }
      })
      expect(userInDb).toBeDefined()
      expect(userInDb?.email).toBe(email)
      const anonUserInDb = await prisma.anonymousUser.findMany()
      expect(anonUserInDb.length).toBe(0)
    })
  })

  describe('given expired email token', () => {
    it('should throw an error if the token is expired', async () => {
      const expiredDate = new Date()
      expiredDate.setHours(expiredDate.getHours() - 2)
      const token = encrypt(`test@test.com#${expiredDate.toISOString()}`, process.env.EMAIL_ENCRYPTION_KEY)
      const args = {
        params: {
          username: "username",
          password: "password",
          name: "Jeff",
          emailToken: token
        }
      }
      try {
        expect.assertions(1)
        await completeAccount(args, context)
      } catch (e) {
        if (e instanceof GraphQLError) {
          expect(e.message).toBe("Token expired")
        }
      }
    })
  })
})

