import { Episode, QueryResolvers, SeasonPerson, SeasonRole } from "../../__generated__/graphql";
import ContentID from "../../types/ContentID";

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
  const cast = season.aggregate_credits.cast.map(mapPerson)
  const crew = season.aggregate_credits.crew.map(mapPerson)
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

function mapEpisode(episode: any): Episode {
  return {
    id: episode.id,
    name: episode.name,
    overview: episode.overview,
    episode_number: episode.episode_number,
    still_url: `https://image.tmdb.org/t/p/original${episode.still_path}`,
    runtime: episode.runtime,
  }
}

function mapPerson(person: any): SeasonPerson {
  let roles: SeasonRole[] = (person.roles || person.jobs).map((r: any) => {
    const role: SeasonRole = {
      id: r.credit_id,
      role: r.character || r.job,
      episodeCount: r.episode_count,
    }
    return role;
  })
  return {
    id: person.id,
    name: person.name,
    imageUrl: `https://image.tmdb.org/t/p/original${person.profile_path}`,
    roles,
    share_url: `https://cut.watch/person/${person.id}`
  }
}

export default seasonResolver;
