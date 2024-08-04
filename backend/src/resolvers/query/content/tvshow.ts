import { ContentType } from "@prisma/client";
import { ExtendedTvShow, ContentType as GqlContentType } from "../../../__generated__/graphql";
import prisma from "../../../prisma";
import importTmbdContent from "../../../db/tmdbImporter";
import contentDbToGqlMapper, { ResolvedContent, contentInclude } from "../../mappers/contentDbToGqlMapper";
import { DeepPartial } from "utility-types";
import TMDB from "../../../datasources/TMDB";
import extendedContentMapper from "../../mappers/extendedContentMapper";
import Provider from "../../../types/providers";
import ContentID from "../../../types/ContentID";

export default async function tvShowResolver(contentId: ContentID, tmdb: TMDB): Promise<DeepPartial<ExtendedTvShow>> {
  let tmdbShow: any;
  let importedShow: ResolvedContent;
  switch (contentId.provider) {
    case Provider.TMDB:
      tmdbShow = await tmdb.fetchTvShow(contentId.id);
      importedShow = await importTmbdContent(tmdbShow, "en", "US", ContentType.TV_SHOW);
      break;
    default:
      const cutShow = await prisma.content.findUnique({
        where: { id: contentId.id },
        include: contentInclude
      });
      if (!cutShow) {
        throw new Error(`Show with id ${contentId.toString()} not found`);
      }
      if (!cutShow.tmdbId) {
        throw new Error(`Show with id ${contentId.toString()} has no tmdbId`);
      }
      tmdbShow = await tmdb.fetchTvShow(cutShow.tmdbId.toString());
      importedShow = cutShow;
  }

  const gqlContent = contentDbToGqlMapper(importedShow);

  const seasons = tmdbShow.seasons.map((s: any) => {
    let seasonAirDate: Date | undefined
    if (s.air_date) {
      seasonAirDate = new Date(s.air_date);
    }
    return {
      id: s.id,
      name: s.name,
      overview: s.overview,
      season_number: s.season_number,
      episode_count: s.episode_count,
      air_date: seasonAirDate,
      poster_url: `https://image.tmdb.org/t/p/original${s.poster_path}`
    }
  })

  // find a season with season_number 0 and move it to the back 
  const zeroSeasonIndex = seasons.findIndex((s: any) => s.season_number === 0);
  if (zeroSeasonIndex !== -1) {
    seasons.push(seasons.splice(zeroSeasonIndex, 1)[0]);
  }

  const extendedContent = extendedContentMapper(tmdbShow)

  return {
    ...gqlContent,
    ...extendedContent,
    __typename: "ExtendedTVShow",
    seasons,
    seasonCount: tmdbShow.number_of_seasons,
    episodeCount: tmdbShow.number_of_episodes,
    type: GqlContentType.TvShow,
  };
}
