import { Episode, Person, QueryResolvers, SeasonPerson, SeasonRole } from "../../__generated__/graphql";
import ContentID from "../../types/ContentID";
import mapEpisode from "../mappers/mapEpisode";
import mapPerson from "../mappers/mapPerson";

const episodeResolver: QueryResolvers["episode"] = async (_parent, args, { dataSources: { tmdb } }) => {
  const { seriesId, seasonNumber, episodeNumber } = args;
  const tmdbId = await ContentID.fromString(seriesId).tmdbId();
  const episode = await tmdb.fetchEpisode(tmdbId, seasonNumber, episodeNumber);
  const mappedEpisode = mapEpisode(episode)
  let airDate: Date | null = null;
  if (episode.air_date) {
    airDate = new Date(episode.air_date);
  }
  const cast: Person[] = episode.credits.cast.map(mapPerson)
  const crew: Person[] = episode.credits.crew.map(mapPerson)
  const guestStars: Person[] = episode.credits.guest_stars.map(mapPerson)
  return {
    ...mappedEpisode,
    __typename: "ExtendedEpisode",
    cast,
    crew,
    guestStars,
    stills: episode.images.stills.map((s: any) => `https://image.tmdb.org/t/p/original${s.file_path}`)
  }
}

export default episodeResolver;
