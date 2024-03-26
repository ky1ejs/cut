import prisma from "../src/prisma"
import sha256 from "../src/services/sha-256"


function main(): Promise<void> {
  return prisma.user.create({
    data: {
      username: "test",
      email: "test@test.com",
      password: "test",
      hashedEmail: sha256("test@test.com"),
      name: "Testy Test",
    }
  }).then(() => { })
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
