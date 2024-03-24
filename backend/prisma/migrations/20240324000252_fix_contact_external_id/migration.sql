/*
  Warnings:

  - A unique constraint covering the columns `[phoneNumber,userId,externalId]` on the table `PhoneContact` will be added. If there are existing duplicate values, this will fail.
  - Made the column `externalId` on table `EmailContact` required. This step will fail if there are existing NULL values in that column.
  - Made the column `externalId` on table `PhoneContact` required. This step will fail if there are existing NULL values in that column.

*/
-- DropIndex
DROP INDEX "PhoneContact_countryCode_phoneNumber_userId_key";

-- AlterTable
ALTER TABLE "EmailContact" ALTER COLUMN "externalId" SET NOT NULL;

-- AlterTable
ALTER TABLE "PhoneContact" ALTER COLUMN "externalId" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "PhoneContact_phoneNumber_userId_externalId_key" ON "PhoneContact"("phoneNumber", "userId", "externalId");
