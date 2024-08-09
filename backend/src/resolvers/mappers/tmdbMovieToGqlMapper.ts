import { getImageBaseUrl } from "../../tmbd/image_base";
import ContentID from "../../types/ContentID";
import Provider from "../../types/providers";
import { ContentType, Genre, Content } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { DeepPartial } from "utility-types";

export default async function contentTmdbToGqlMapper(content: any): Promise<DeepPartial<Content> | null> {
  if (content.media_type !== 'movie' && content.media_type !== 'tv') {
    return null;
  }
  const tmdbGenres = await fetchGenres();
  const genres: Genre[] = content.genre_ids.map((id: number) =>
    tmdbGenres.find((g) => g.tmdbId === id) ?? null
  ).filter((g: (Genre | null)) => g !== null);
  const type = content.media_type === 'movie' ? ContentType.Movie : ContentType.TvShow;
  const id = new ContentID(type, Provider.TMDB, content.id.toString()).toString();
  let release_data: Date | null = null;
  if (content.release_date) {
    release_data = new Date(content.release_date);
  }
  if (content.first_air_date) {
    release_data = new Date(content.first_air_date);
  }
  return {
    id,
    allIds: [id],
    title: content.original_name || content.original_title,
    poster_url: getImageBaseUrl() + content.poster_path,
    releaseDate: release_data,
    genres,
    type,
    mainGenre: genres[0],
    url: `https://cut.watch/content/${content.id}`
  }
}

let genres: { id: number, tmdbId: number, name: string }[] | undefined;
async function fetchGenres() {
  if (genres) {
    return genres;
  }
  const tmdbGenres = await prisma.genre.findMany({
    where: {
      tmdbId: {
        not: null
      }
    },
    include: {
      locales: {
        where: {
          language_ISO_639_1: 'en'
        }
      }
    }
  });
  const mappedGenres = tmdbGenres.map((genre) => ({
    id: genre.id,
    tmdbId: genre.tmdbId!,
    name: genre.locales[0].name
  }));
  genres = mappedGenres;
  return mappedGenres;
};