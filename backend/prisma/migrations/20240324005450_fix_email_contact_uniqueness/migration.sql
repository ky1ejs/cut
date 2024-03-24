/*
  Warnings:

  - A unique constraint covering the columns `[email,userId,externalId]` on the table `EmailContact` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "EmailContact_email_userId_key";

-- CreateIndex
CREATE UNIQUE INDEX "EmailContact_email_userId_externalId_key" ON "EmailContact"("email", "userId", "externalId");
