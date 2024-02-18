-- CreateEnum
CREATE TYPE "CollectionType" AS ENUM ('POPULAR', 'TOP_RATED', 'UPCOMING', 'NOW_PLAYING', 'TRENDING_DAILY', 'TRENDING_WEEKLY');

-- AlterTable
ALTER TABLE "Movie" ALTER COLUMN "releaseDate" DROP NOT NULL;

-- CreateTable
CREATE TABLE "MovieCollection" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "type" "CollectionType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "movieId" TEXT NOT NULL,

    CONSTRAINT "MovieCollection_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MovieCollection_type_movieId_key" ON "MovieCollection"("type", "movieId");

-- AddForeignKey
ALTER TABLE "MovieCollection" ADD CONSTRAINT "MovieCollection_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
