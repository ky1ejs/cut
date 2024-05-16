import { Episode } from "../../__generated__/graphql";
import mapMaybeDate from "./mapMaybeDate";

export default function mapEpisode(episode: any): Episode {
  return {
    id: episode.id,
    name: episode.name,
    air_date: mapMaybeDate(episode.air_date),
    overview: episode.overview,
    season_number: episode.season_number,
    episode_number: episode.episode_number,
    still_url: `https://image.tmdb.org/t/p/original${episode.still_path}`,
    runtime: episode.runtime,
  }
}
