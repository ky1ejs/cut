ALTER TABLE "AnnonymousRating" RENAME CONSTRAINT "AnnonymousRating_movieId_fkey" TO "AnnonymousRating_contentId_fkey";
ALTER TABLE "AnnonymousWatchList" RENAME CONSTRAINT "AnnonymousWatchList_movieId_fkey" TO "AnnonymousWatchList_contentId_fkey";
ALTER TABLE "Movie" RENAME CONSTRAINT "Movie_mainGenreId_fkey" TO "Content_mainGenreId_fkey";
ALTER TABLE "Movie" RENAME CONSTRAINT "Movie_pkey" TO "Content_pkey";
ALTER TABLE "MovieCollection" RENAME CONSTRAINT "MovieCollection_movieId_fkey" TO "ContentCollection_contentId_fkey";
ALTER TABLE "MovieCollection" RENAME CONSTRAINT "MovieCollection_pkey" TO "ContentCollection_pkey";
ALTER TABLE "MovieGenre" RENAME CONSTRAINT "MovieGenre_genreId_fkey" TO "ContentGenre_genreId_fkey";
ALTER TABLE "MovieGenre" RENAME CONSTRAINT "MovieGenre_movieId_fkey" TO "ContentGenre_contentId_fkey";
ALTER TABLE "MovieGenre" RENAME CONSTRAINT "MovieGenre_pkey" TO "ContentGenre_pkey";
ALTER TABLE "MovieImage" RENAME CONSTRAINT "MovieImage_movieId_fkey" TO "ContentImage_contentId_fkey";
ALTER TABLE "MovieImage" RENAME CONSTRAINT "MovieImage_pkey" TO "ContentImage_pkey";
ALTER TABLE "MovieTranslation" RENAME CONSTRAINT "MovieTranslation_movieId_fkey" TO "ContentTranslation_contentId_fkey";
ALTER TABLE "MovieTranslation" RENAME CONSTRAINT "MovieTranslation_pkey" TO "ContentTranslation_pkey";
ALTER TABLE "Rating" RENAME CONSTRAINT "Rating_movieId_fkey" TO "Rating_contentId_fkey";
ALTER TABLE "WatchList" RENAME CONSTRAINT "WatchList_movieId_fkey" TO "WatchList_contentId_fkey";

ALTER INDEX "AnnonymousWatchList_movieId_userId_key" RENAME TO "AnnonymousWatchList_contentId_userId_key";
ALTER INDEX "WatchList_movieId_userId_key" RENAME TO "WatchList_contentId_userId_key";
ALTER INDEX "MovieGenre_movieId_genreId_key" RENAME TO "ContentGenre_contentId_genreId_key";
ALTER INDEX "MovieCollection_type_movieId_key" RENAME TO "ContentCollection_type_contentId_key";
ALTER INDEX "Movie_fandangoId_key" RENAME TO "Content_fandangoId_key";
ALTER INDEX "Movie_imdbId_key" RENAME TO "Content_imdbId_key";
ALTER INDEX "Movie_tmdbId_key" RENAME TO "Content_tmdbId_key";
ALTER INDEX "MovieImage_url_key" RENAME TO "ContentImage_url_key";
ALTER INDEX "AnnonymousRating_movieId_userId_key" RENAME TO "AnnonymousRating_contentId_userId_key";
ALTER INDEX "Rating_movieId_userId_key" RENAME TO "Rating_contentId_userId_key";

ALTER TABLE "AnnonymousRating" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "AnnonymousWatchList" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "Rating" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "User" RENAME COLUMN "favoriteMovies" TO "favoriteContentIds";
ALTER TABLE "WatchList" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "MovieCollection" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "MovieGenre" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "MovieImage" RENAME COLUMN "movieId" TO "contentId";
ALTER TABLE "MovieTranslation" RENAME COLUMN "movieId" TO "contentId";

ALTER TABLE "Movie" RENAME TO "Content";
ALTER TABLE "MovieCollection" RENAME TO "ContentCollection";
ALTER TABLE "MovieGenre" RENAME TO "ContentGenre";
ALTER TABLE "MovieImage" RENAME TO "ContentImage";
ALTER TABLE "MovieTranslation" RENAME TO "ContentTranslation";