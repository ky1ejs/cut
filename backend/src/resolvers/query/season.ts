import { Episode, QueryResolvers, SeasonPerson, SeasonRole } from "../../__generated__/graphql";
import ContentID from "../../types/ContentID";
import mapEpisode from "../mappers/mapEpisode";
import mapSeasonPerson from "../mappers/mapSeasonPerson";

const seasonResolver: QueryResolvers["season"] = async (_parent, args, { dataSources: { tmdb } }) => {
  const { seriesId, seasonNumber } = args;
  const contentId = ContentID.fromString(seriesId);
  const tmdbId = await contentId.tmdbId();
  const season = await tmdb.fetchSeason(tmdbId, seasonNumber);
  const episodes = season.episodes.map(mapEpisode)
  console.log(tmdbId)
  let airDate: Date | null = null;
  if (season.air_date) {
    airDate = new Date(season.air_date);
  }
  const cast = season.aggregate_credits.cast.map(mapSeasonPerson)
  const crew = season.aggregate_credits.crew.map(mapSeasonPerson)
  return {
    id: season.id,
    name: season.name,
    overview: season.overview,
    poster_url: `https://image.tmdb.org/t/p/original${season.poster_path}`,
    season_number: season.season_number,
    episodes,
    air_date: airDate,
    episode_count: season.episodes.length,
    cast,
    crew,
  }
}

export default seasonResolver;
