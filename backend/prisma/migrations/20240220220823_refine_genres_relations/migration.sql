-- CreateTable
CREATE TABLE "_MovieToMovieProvider" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_MovieToMovieProvider_AB_unique" ON "_MovieToMovieProvider"("A", "B");

-- CreateIndex
CREATE INDEX "_MovieToMovieProvider_B_index" ON "_MovieToMovieProvider"("B");

-- AddForeignKey
ALTER TABLE "MovieProvider" ADD CONSTRAINT "MovieProvider_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MovieToMovieProvider" ADD CONSTRAINT "_MovieToMovieProvider_A_fkey" FOREIGN KEY ("A") REFERENCES "Movie"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MovieToMovieProvider" ADD CONSTRAINT "_MovieToMovieProvider_B_fkey" FOREIGN KEY ("B") REFERENCES "MovieProvider"("id") ON DELETE CASCADE ON UPDATE CASCADE;
