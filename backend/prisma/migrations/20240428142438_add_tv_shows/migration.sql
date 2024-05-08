/*
  Warnings:

  - Added the required column `contentType` to the `Movie` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('MOVIE', 'TV_SHOW');

-- AlterTable
ALTER TABLE "Movie" ADD COLUMN  "contentType" "ContentType";

UPDATE "Movie" SET "contentType" = 'MOVIE';

ALTER TABLE "Movie" ALTER COLUMN "contentType" SET NOT NULL;

