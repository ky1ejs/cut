/*
  Warnings:

  - The primary key for the `AnnonymousDevice` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `AnnonymousDevice` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `sessionId` column on the `AnnonymousDevice` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `AnnonymousWatchList` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `AnnonymousWatchList` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `AnonymousUser` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `AnonymousUser` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Device` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `sessionId` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `EmailContact` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `EmailContact` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Follow` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Follow` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `LocalizedGenre` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `LocalizedGenre` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Movie` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Movie` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `MovieCollection` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `MovieCollection` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `MovieGenre` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `MovieGenre` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `MovieImage` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `MovieImage` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `MovieTranslation` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `MovieTranslation` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `PhoneContact` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `PhoneContact` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `WatchList` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `WatchList` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `userId` on the `AnnonymousDevice` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `AnnonymousWatchList` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `AnnonymousWatchList` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `Device` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `EmailContact` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `followerId` on the `Follow` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `followingId` on the `Follow` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `MovieCollection` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `MovieGenre` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `MovieImage` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `MovieTranslation` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `PhoneContact` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `WatchList` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `movieId` on the `WatchList` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "TokenEnv" AS ENUM ('STAGING', 'PRODUCTION');

-- CreateEnum
CREATE TYPE "PushPlatform" AS ENUM ('IOS', 'ANDROID', 'WEB');

-- DropForeignKey
ALTER TABLE "AnnonymousDevice" DROP CONSTRAINT "AnnonymousDevice_userId_fkey";

-- DropForeignKey
ALTER TABLE "AnnonymousWatchList" DROP CONSTRAINT "AnnonymousWatchList_movieId_fkey";

-- DropForeignKey
ALTER TABLE "AnnonymousWatchList" DROP CONSTRAINT "AnnonymousWatchList_userId_fkey";

-- DropForeignKey
ALTER TABLE "Device" DROP CONSTRAINT "Device_userId_fkey";

-- DropForeignKey
ALTER TABLE "EmailContact" DROP CONSTRAINT "EmailContact_userId_fkey";

-- DropForeignKey
ALTER TABLE "Follow" DROP CONSTRAINT "Follow_followerId_fkey";

-- DropForeignKey
ALTER TABLE "Follow" DROP CONSTRAINT "Follow_followingId_fkey";

-- DropForeignKey
ALTER TABLE "MovieCollection" DROP CONSTRAINT "MovieCollection_movieId_fkey";

-- DropForeignKey
ALTER TABLE "MovieGenre" DROP CONSTRAINT "MovieGenre_movieId_fkey";

-- DropForeignKey
ALTER TABLE "MovieImage" DROP CONSTRAINT "MovieImage_movieId_fkey";

-- DropForeignKey
ALTER TABLE "MovieTranslation" DROP CONSTRAINT "MovieTranslation_movieId_fkey";

-- DropForeignKey
ALTER TABLE "PhoneContact" DROP CONSTRAINT "PhoneContact_userId_fkey";

-- DropForeignKey
ALTER TABLE "WatchList" DROP CONSTRAINT "WatchList_movieId_fkey";

-- DropForeignKey
ALTER TABLE "WatchList" DROP CONSTRAINT "WatchList_userId_fkey";

-- AlterTable
ALTER TABLE "AnnonymousDevice" DROP CONSTRAINT "AnnonymousDevice_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "sessionId",
ADD COLUMN     "sessionId" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ADD CONSTRAINT "AnnonymousDevice_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "AnnonymousWatchList" DROP CONSTRAINT "AnnonymousWatchList_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ADD CONSTRAINT "AnnonymousWatchList_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "AnonymousUser" DROP CONSTRAINT "AnonymousUser_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ADD CONSTRAINT "AnonymousUser_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Device" DROP CONSTRAINT "Device_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "sessionId",
ADD COLUMN     "sessionId" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ADD CONSTRAINT "Device_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "EmailContact" DROP CONSTRAINT "EmailContact_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ADD CONSTRAINT "EmailContact_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Follow" DROP CONSTRAINT "Follow_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "followerId",
ADD COLUMN     "followerId" UUID NOT NULL,
DROP COLUMN "followingId",
ADD COLUMN     "followingId" UUID NOT NULL,
ADD CONSTRAINT "Follow_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "LocalizedGenre" DROP CONSTRAINT "LocalizedGenre_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ADD CONSTRAINT "LocalizedGenre_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Movie" DROP CONSTRAINT "Movie_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ADD CONSTRAINT "Movie_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "MovieCollection" DROP CONSTRAINT "MovieCollection_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
ADD CONSTRAINT "MovieCollection_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "MovieGenre" DROP CONSTRAINT "MovieGenre_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
ADD CONSTRAINT "MovieGenre_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "MovieImage" DROP CONSTRAINT "MovieImage_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
ADD CONSTRAINT "MovieImage_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "MovieTranslation" DROP CONSTRAINT "MovieTranslation_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
ADD CONSTRAINT "MovieTranslation_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "PhoneContact" DROP CONSTRAINT "PhoneContact_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ADD CONSTRAINT "PhoneContact_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "WatchList" DROP CONSTRAINT "WatchList_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
DROP COLUMN "movieId",
ADD COLUMN     "movieId" UUID NOT NULL,
ADD CONSTRAINT "WatchList_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "PushToken" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "token" TEXT NOT NULL,
    "env" "TokenEnv" NOT NULL,
    "platform" "PushPlatform" NOT NULL,
    "device_id" UUID NOT NULL,

    CONSTRAINT "PushToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AnnoymousPushToken" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "token" TEXT NOT NULL,
    "env" "TokenEnv" NOT NULL,
    "platform" "PushPlatform" NOT NULL,
    "device_id" UUID NOT NULL,

    CONSTRAINT "AnnoymousPushToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SentNotification" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "idempotencyKey" TEXT,
    "repeatLimit" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,

    CONSTRAINT "SentNotification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PushToken_device_id_key" ON "PushToken"("device_id");

-- CreateIndex
CREATE UNIQUE INDEX "AnnoymousPushToken_device_id_key" ON "AnnoymousPushToken"("device_id");

-- CreateIndex
CREATE UNIQUE INDEX "AnnonymousDevice_sessionId_key" ON "AnnonymousDevice"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "AnnonymousWatchList_movieId_userId_key" ON "AnnonymousWatchList"("movieId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Device_sessionId_key" ON "Device"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailContact_email_userId_externalId_key" ON "EmailContact"("email", "userId", "externalId");

-- CreateIndex
CREATE UNIQUE INDEX "Follow_followerId_followingId_key" ON "Follow"("followerId", "followingId");

-- CreateIndex
CREATE UNIQUE INDEX "MovieCollection_type_movieId_key" ON "MovieCollection"("type", "movieId");

-- CreateIndex
CREATE UNIQUE INDEX "MovieGenre_movieId_genreId_key" ON "MovieGenre"("movieId", "genreId");

-- CreateIndex
CREATE UNIQUE INDEX "PhoneContact_phoneNumber_userId_externalId_key" ON "PhoneContact"("phoneNumber", "userId", "externalId");

-- CreateIndex
CREATE UNIQUE INDEX "WatchList_movieId_userId_key" ON "WatchList"("movieId", "userId");

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Device" ADD CONSTRAINT "Device_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PushToken" ADD CONSTRAINT "PushToken_device_id_fkey" FOREIGN KEY ("device_id") REFERENCES "Device"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnnoymousPushToken" ADD CONSTRAINT "AnnoymousPushToken_device_id_fkey" FOREIGN KEY ("device_id") REFERENCES "AnnonymousDevice"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SentNotification" ADD CONSTRAINT "SentNotification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnnonymousDevice" ADD CONSTRAINT "AnnonymousDevice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AnonymousUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PhoneContact" ADD CONSTRAINT "PhoneContact_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmailContact" ADD CONSTRAINT "EmailContact_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WatchList" ADD CONSTRAINT "WatchList_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WatchList" ADD CONSTRAINT "WatchList_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnnonymousWatchList" ADD CONSTRAINT "AnnonymousWatchList_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnnonymousWatchList" ADD CONSTRAINT "AnnonymousWatchList_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AnonymousUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieTranslation" ADD CONSTRAINT "MovieTranslation_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieGenre" ADD CONSTRAINT "MovieGenre_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieImage" ADD CONSTRAINT "MovieImage_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovieCollection" ADD CONSTRAINT "MovieCollection_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE CASCADE ON UPDATE CASCADE;
