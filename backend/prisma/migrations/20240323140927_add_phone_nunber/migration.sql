/*
  Warnings:

  - A unique constraint covering the columns `[hashedEmail]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `hashedEmail` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "countryCode" CITEXT,
ADD COLUMN     "hashedEmail" TEXT NOT NULL,
ADD COLUMN     "hashedPhoneNumber" TEXT,
ADD COLUMN     "phoneNumber" CITEXT;

-- CreateTable
CREATE TABLE "PhoneContact" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "countryCode" CITEXT,
    "phoneNumber" CITEXT NOT NULL,
    "name" TEXT NOT NULL,
    "externalId" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "PhoneContact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailContact" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "email" CITEXT NOT NULL,
    "name" TEXT NOT NULL,
    "externalId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,

    CONSTRAINT "EmailContact_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PhoneContact_countryCode_phoneNumber_userId_key" ON "PhoneContact"("countryCode", "phoneNumber", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailContact_email_userId_key" ON "EmailContact"("email", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "User_hashedEmail_key" ON "User"("hashedEmail");

-- AddForeignKey
ALTER TABLE "PhoneContact" ADD CONSTRAINT "PhoneContact_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmailContact" ADD CONSTRAINT "EmailContact_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
