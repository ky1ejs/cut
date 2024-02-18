/*
  Warnings:

  - You are about to drop the column `tmdbId` on the `WatchList` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[movieId,userId]` on the table `WatchList` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `movieId` to the `WatchList` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Provider" AS ENUM ('TMDB', 'IMDB', 'FANDANGO');

-- CreateEnum
CREATE TYPE "ImageType" AS ENUM ('POSTER', 'BACKDROP', 'STILL');

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
    "releaseDate" DATE NOT NULL,
    "originalLanguage" TEXT NOT NULL,
    "originalTitle" TEXT NOT NULL,
    "synopsis" TEXT NOT NULL,
    "mainGenreId" INTEGER NOT NULL,
    "mainProviderId" TEXT,

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
CREATE TABLE "ProviderMovieGenre" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "provider" "Provider" NOT NULL,
    "externalID" TEXT NOT NULL,
    "genreId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProviderMovieGenre_pkey" PRIMARY KEY ("id")
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
CREATE TABLE "MovieProvider" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "movieId" TEXT NOT NULL,
    "provider" "Provider" NOT NULL,
    "externalId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MovieProvider_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MovieGenre_movieId_genreId_key" ON "MovieGenre"("movieId", "genreId");

-- CreateIndex
CREATE UNIQUE INDEX "ProviderMovieGenre_externalID_provider_key" ON "ProviderMovieGenre"("externalID", "provider");

-- CreateIndex
CREATE UNIQUE INDEX "MovieImage_url_key" ON "MovieImage"("url");

-- CreateIndex
CREATE UNIQUE INDEX "LocalizedGenre_genreId_language_key" ON "LocalizedGenre"("genreId", "language");

-- CreateIndex
CREATE UNIQUE INDEX "MovieProvider_externalId_provider_key" ON "MovieProvider"("externalId", "provider");

-- CreateIndex
CREATE UNIQUE INDEX "WatchList_movieId_userId_key" ON "WatchList"("movieId", "userId");

-- AddForeignKey
ALTER TABLE "WatchList" ADD CONSTRAINT "WatchList_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movie" ADD CONSTRAINT "Movie_mainProviderId_fkey" FOREIGN KEY ("mainProviderId") REFERENCES "MovieProvider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieTranslation" ADD CONSTRAINT "MovieTranslation_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieGenre" ADD CONSTRAINT "MovieGenre_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieGenre" ADD CONSTRAINT "MovieGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProviderMovieGenre" ADD CONSTRAINT "ProviderMovieGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieImage" ADD CONSTRAINT "MovieImage_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LocalizedGenre" ADD CONSTRAINT "LocalizedGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Action
INSERT INTO "Genre" ("id") VALUES (1);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (1, 'en', 'Action');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '28', 1);

-- Adventure
INSERT INTO "Genre" ("id") VALUES (2);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (2, 'en', 'Adventure');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '12', 2);

-- Animation
INSERT INTO "Genre" ("id") VALUES (3);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (3, 'en', 'Animation');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '16', 3);

-- Comedy
INSERT INTO "Genre" ("id") VALUES (4);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (4, 'en', 'Comedy');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '35', 4);

-- Crime
INSERT INTO "Genre" ("id") VALUES (5);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (5, 'en', 'Crime');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '80', 5);

-- Documentary
INSERT INTO "Genre" ("id") VALUES (6);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (6, 'en', 'Documentary');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '99', 6);

-- Drama
INSERT INTO "Genre" ("id") VALUES (7);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (7, 'en', 'Drama');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '18', 7);

-- Family
INSERT INTO "Genre" ("id") VALUES (8);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (8, 'en', 'Family');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '10751', 8);

-- Fantasy
INSERT INTO "Genre" ("id") VALUES (9);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (9, 'en', 'Fantasy');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '14', 9);

-- History
INSERT INTO "Genre" ("id") VALUES (10);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (10, 'en', 'History');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '36', 10);

-- Horror
INSERT INTO "Genre" ("id") VALUES (11);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (11, 'en', 'Horror');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '27', 11);

-- Music
INSERT INTO "Genre" ("id") VALUES (12);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (12, 'en', 'Music');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '10402', 12);

-- Mystery
INSERT INTO "Genre" ("id") VALUES (13);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (13, 'en', 'Mystery');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '9648', 13);

-- Romance
INSERT INTO "Genre" ("id") VALUES (14);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (14, 'en', 'Romance');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '10749', 14);

-- Science Fiction
INSERT INTO "Genre" ("id") VALUES (15);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (15, 'en', 'Science Fiction');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '878', 15);

-- TV Movie
INSERT INTO "Genre" ("id") VALUES (16);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (16, 'en', 'TV Movie');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '10770', 16);

-- Thriller
INSERT INTO "Genre" ("id") VALUES (17);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (17, 'en', 'Thriller');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '53', 17);

-- War
INSERT INTO "Genre" ("id") VALUES (18);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (18, 'en', 'War');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '10752', 18);

-- Western
INSERT INTO "Genre" ("id") VALUES (19);
INSERT INTO "LocalizedGenre" ("genreId", "language", "name") VALUES (19, 'en', 'Western');
INSERT INTO "ProviderMovieGenre" ("provider", "externalID", "genreId") VALUES ('TMDB', '37', 19);
