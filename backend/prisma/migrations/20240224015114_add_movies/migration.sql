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
    "language_ISO_639_1" TEXT NOT NULL,
    "country_ISO_3166_1" TEXT NOT NULL,
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
    "language_ISO_639_1" TEXT NOT NULL,
    "country_ISO_3166_1" TEXT NOT NULL,
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
    "language_ISO_639_1" TEXT NOT NULL,
    "country_ISO_3166_1" TEXT NOT NULL,
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
CREATE UNIQUE INDEX "LocalizedGenre_genreId_language_ISO_639_1_country_ISO_3166__key" ON "LocalizedGenre"("genreId", "language_ISO_639_1", "country_ISO_3166_1");

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
-- Adventure
INSERT INTO "Genre" ("id", "tmdbId") VALUES (2, 12);
-- Animation
INSERT INTO "Genre" ("id", "tmdbId") VALUES (3, 16);
-- Comedy
INSERT INTO "Genre" ("id", "tmdbId") VALUES (4, 35);
-- Crime
INSERT INTO "Genre" ("id", "tmdbId") VALUES (5, 80);
-- Documentary
INSERT INTO "Genre" ("id", "tmdbId") VALUES (6, 99);
-- Drama
INSERT INTO "Genre" ("id", "tmdbId") VALUES (7, 18);
-- Family
INSERT INTO "Genre" ("id", "tmdbId") VALUES (8, 10751);
-- Fantasy
INSERT INTO "Genre" ("id", "tmdbId") VALUES (9, 14);
-- History
INSERT INTO "Genre" ("id", "tmdbId") VALUES (10, 36);
-- Horror
INSERT INTO "Genre" ("id", "tmdbId") VALUES (11, 27);
-- Music
INSERT INTO "Genre" ("id", "tmdbId") VALUES (12, 10402);
-- Mystery
INSERT INTO "Genre" ("id", "tmdbId") VALUES (13, 9648);
-- Romance
INSERT INTO "Genre" ("id", "tmdbId") VALUES (14, 10749);
-- Science Fiction
INSERT INTO "Genre" ("id", "tmdbId") VALUES (15, 878);
-- TV Movie
INSERT INTO "Genre" ("id", "tmdbId") VALUES (16, 10770);
-- Thriller
INSERT INTO "Genre" ("id", "tmdbId") VALUES (17, 53);
-- War
INSERT INTO "Genre" ("id", "tmdbId") VALUES (18, 10752);
-- Western
INSERT INTO "Genre" ("id", "tmdbId") VALUES (19, 37);

-- Trigger to automatically update the `updatedAt` column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_movies_updated_at
BEFORE UPDATE ON "Movie"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_movie_translations_updated_at
BEFORE UPDATE ON "MovieTranslation"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_movie_genres_updated_at
BEFORE UPDATE ON "MovieGenre"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_movie_images_updated_at
BEFORE UPDATE ON "MovieImage"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_genres_updated_at
BEFORE UPDATE ON "Genre"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_localized_genres_updated_at
BEFORE UPDATE ON "LocalizedGenre"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_movie_collections_updated_at
BEFORE UPDATE ON "MovieCollection"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_watch_list_updated_at
BEFORE UPDATE ON "WatchList"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_devices_updated_at
BEFORE UPDATE ON "Device"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the `updatedAt` column
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON "User"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
