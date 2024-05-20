import { ExtendedContent, Person, Trailer } from "../../__generated__/graphql";
import mapPerson from "./mapPerson";
import watchProviderMapper from "./watchProviderMapper";

export default function extendedContentMapper(content: any): ExtendedContent {
  const youTubeTrailer = content.videos.results.find((v: any) => v.type === "Trailer" && v.site === "YouTube");
  let trailer: Trailer | null = null;
  if (youTubeTrailer) {
    trailer = {
      url: `https://www.youtube.com/watch?v=${youTubeTrailer.key}`,
      thumbnail_url: `https://img.youtube.com/vi/${youTubeTrailer.key}/hqdefault.jpg`,
    }
  }

  const watchProviders = watchProviderMapper(content["watch/providers"].results["US"])

  const cast = content.credits.cast.slice(0, 10).map(mapPerson)
  const crew: Person[] = content.credits.crew.map(mapPerson)

  return {
    cast,
    crew,
    overview: content.overview,
    watchProviders,
    userRating: content.vote_average / 10,
    trailer
  }
}
