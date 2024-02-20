-- AlterTable
ALTER TABLE "Movie" ALTER COLUMN "mainGenreId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Movie" ADD CONSTRAINT "Movie_mainGenreId_fkey" FOREIGN KEY ("mainGenreId") REFERENCES "Genre"("id") ON DELETE SET NULL ON UPDATE CASCADE;
