import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const user1 = await createUser("test-1@test.com", "test-user-1")
  const user2 = await createUser("test-2@test.com", "test-user-2")
  await createGenreLocale()
  const movie = await createMovie()

  await prisma.device.create({
    data: {
      name: "test-device-1",
      userId: user1.id,
      sessionId: "6f751298-f47a-4cb0-b409-f18f6db6309f"
    }
  })

  await prisma.follow.create({
    data: {
      followerId: user1.id,
      followingId: user2.id
    }
  })
  await prisma.follow.create({
    data: {
      followerId: user2.id,
      followingId: user1.id
    }
  })

  await prisma.rating.create({
    data: {
      userId: user1.id,
      contentId: movie.id,
      rating: 5
    }
  })

  await prisma.rating.create({
    data: {
      userId: user2.id,
      contentId: movie.id,
      rating: 5
    }
  })
}

async function createUser(email: string, username: string) {
  return await prisma.user.create({
    data: {
      createdAt: new Date(),
      updatedAt: new Date(),
      bio: 'A lovely bio',
      email,
      name: username,
      username: username,
      hashedEmail: email,
      hashedPhoneNumber: 'hashedPhoneNumber',
      phoneNumber: 'phoneNumber',
      followerCount: 0,
      followingCount: 0,
      favoriteContentIds: [],
    }
  })
}

async function createMovie() {
  // 2024-08-14 00:06:37.685	2024-08-14 00:06:37.685	1994-06-23	en	Forrest Gump		4	13			369fdb00-5f67-4ed1-9389-ff9a8fe20184	MOVIE
  return await prisma.content.create({
    data: {
      createdAt: new Date(),
      updatedAt: new Date(),
      originalTitle: 'Forrest Gump',
      synopsis: "A man with a low IQ has accomplished great things in his life and been present during significant historic events—in each case, far exceeding what anyone imagined he could do. But despite all he has achieved, his one true love eludes him.",
      releaseDate: new Date('1994-06-23'),
      tmdbId: 13,
      imdbId: 'tt0109830',
      mainGenreId: 4,
      genres: {
        create: {
          genreId: 4
        }
      },
      contentType: 'MOVIE',
      originalLanguage: 'en',
    }
  })
}

async function createGenreLocale() {
  await prisma.localizedGenre.create({
    data: {
      genreId: 4,
      createdAt: new Date(),
      updatedAt: new Date(),
      name: 'Comedy',
      language_ISO_639_1: 'en',
      country_ISO_3166_1: 'US'
    }
  })
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
