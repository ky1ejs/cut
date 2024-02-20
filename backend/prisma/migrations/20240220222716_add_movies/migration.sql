/*
  Warnings:

  - You are about to drop the column `tmdbId` on the `WatchList` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[movieId,userId]` on the table `WatchList` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `movieId` to the `WatchList` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ImageType" AS ENUM ('POSTER', 'BACKDROP', 'STILL');

-- CreateEnum
CREATE TYPE "CollectionType" AS ENUM ('POPULAR', 'TOP_RATED', 'UPCOMING', 'NOW_PLAYING', 'TRENDING_DAILY', 'TRENDING_WEEKLY');

-- AlterTable
ALTER TABLE "Device" ALTER COLUMN "id" SET DEFAULT gen_random_uuid(),
ALTER COLUMN "sessionId" SET DEFAULT gen_random_uuid(),
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "id" SET DEFAULT gen_random_uuid(),
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "WatchList" DROP COLUMN "tmdbId",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "movieId" TEXT NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "id" SET DEFAULT gen_random_uuid();

-- CreateTable
CREATE TABLE "Movie" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "releaseDate" DATE,
    "originalLanguage" TEXT NOT NULL,
    "originalTitle" TEXT NOT NULL,
    "synopsis" TEXT NOT NULL,
    "mainGenreId" INTEGER,
    "tmdbId" INTEGER,
    "imdbId" TEXT,
    "fandangoId" TEXT,

    CONSTRAINT "Movie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovieTranslation" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "synopsis" TEXT NOT NULL,
    "language" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "movieId" TEXT NOT NULL,

    CONSTRAINT "MovieTranslation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovieGenre" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "movieId" TEXT NOT NULL,
    "genreId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MovieGenre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovieImage" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "url" TEXT NOT NULL,
    "type" "ImageType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "movieId" TEXT NOT NULL,

    CONSTRAINT "MovieImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Genre" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tmdbId" INTEGER,

    CONSTRAINT "Genre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LocalizedGenre" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "genreId" INTEGER NOT NULL,
    "language" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LocalizedGenre_pkey" PRIMARY KEY ("id")
);

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
CREATE UNIQUE INDEX "Movie_tmdbId_key" ON "Movie"("tmdbId");

-- CreateIndex
CREATE UNIQUE INDEX "Movie_imdbId_key" ON "Movie"("imdbId");

-- CreateIndex
CREATE UNIQUE INDEX "Movie_fandangoId_key" ON "Movie"("fandangoId");

-- CreateIndex
CREATE UNIQUE INDEX "MovieGenre_movieId_genreId_key" ON "MovieGenre"("movieId", "genreId");

-- CreateIndex
CREATE UNIQUE INDEX "MovieImage_url_key" ON "MovieImage"("url");

-- CreateIndex
CREATE UNIQUE INDEX "Genre_tmdbId_key" ON "Genre"("tmdbId");

-- CreateIndex
CREATE UNIQUE INDEX "LocalizedGenre_genreId_language_key" ON "LocalizedGenre"("genreId", "language");

-- CreateIndex
CREATE UNIQUE INDEX "MovieCollection_type_movieId_key" ON "MovieCollection"("type", "movieId");

-- CreateIndex
CREATE UNIQUE INDEX "WatchList_movieId_userId_key" ON "WatchList"("movieId", "userId");

-- AddForeignKey
ALTER TABLE "WatchList" ADD CONSTRAINT "WatchList_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movie" ADD CONSTRAINT "Movie_mainGenreId_fkey" FOREIGN KEY ("mainGenreId") REFERENCES "Genre"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieTranslation" ADD CONSTRAINT "MovieTranslation_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieGenre" ADD CONSTRAINT "MovieGenre_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieGenre" ADD CONSTRAINT "MovieGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieImage" ADD CONSTRAINT "MovieImage_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LocalizedGenre" ADD CONSTRAINT "LocalizedGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieCollection" ADD CONSTRAINT "MovieCollection_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Add all genres from TMDB
-- Action
INSERT INTO "Genre" ("id", "tmdbId") VALUES (1, 28);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (1, 'en', 'Action');

-- Adventure
INSERT INTO "Genre" ("id", "tmdbId") VALUES (2, 12);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (2, 'en', 'Adventure');

-- Animation
INSERT INTO "Genre" ("id", "tmdbId") VALUES (3, 16);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (3, 'en', 'Animation');

-- Comedy
INSERT INTO "Genre" ("id", "tmdbId") VALUES (4, 35);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (4, 'en', 'Comedy');

-- Crime
INSERT INTO "Genre" ("id", "tmdbId") VALUES (5, 80);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (5, 'en', 'Crime');

-- Documentary
INSERT INTO "Genre" ("id", "tmdbId") VALUES (6, 99);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (6, 'en', 'Documentary');

-- Drama
INSERT INTO "Genre" ("id", "tmdbId") VALUES (7, 18);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (7, 'en', 'Drama');

-- Family
INSERT INTO "Genre" ("id", "tmdbId") VALUES (8, 10751);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (8, 'en', 'Family');

-- Fantasy
INSERT INTO "Genre" ("id", "tmdbId") VALUES (9, 14);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (9, 'en', 'Fantasy');


-- History
INSERT INTO "Genre" ("id", "tmdbId") VALUES (10, 36);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (10, 'en', 'History');

-- Horror
INSERT INTO "Genre" ("id", "tmdbId") VALUES (11, 27);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (11, 'en', 'Horror');

-- Music
INSERT INTO "Genre" ("id", "tmdbId") VALUES (12, 10402);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (12, 'en', 'Music');

-- Mystery
INSERT INTO "Genre" ("id", "tmdbId") VALUES (13, 9648);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (13, 'en', 'Mystery');

-- Romance
INSERT INTO "Genre" ("id", "tmdbId") VALUES (14, 10749);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (14, 'en', 'Romance');

-- Science Fiction
INSERT INTO "Genre" ("id", "tmdbId") VALUES (15, 878);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (15, 'en', 'Science Fiction');

-- TV Movie
INSERT INTO "Genre" ("id", "tmdbId") VALUES (16, 10770);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (16, 'en', 'TV Movie');

-- Thriller
INSERT INTO "Genre" ("id", "tmdbId") VALUES (17, 53);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (17, 'en', 'Thriller');

-- War
INSERT INTO "Genre" ("id", "tmdbId") VALUES (18, 10752);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (18, 'en', 'War');

-- Western
INSERT INTO "Genre" ("id", "tmdbId") VALUES (19, 37);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (19, 'en', 'Western');
