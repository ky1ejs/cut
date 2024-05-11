import { ExtendedContent, Person } from "../../__generated__/graphql";
import watchProviderMapper from "./watchProviderMapper";

export default function extendedContentMapper(content: any): ExtendedContent {
  const youTubeTrailer = content.videos.results.find((v: any) => v.type === "Trailer" && v.site === "YouTube");
  let trailer: string | null = null;
  if (youTubeTrailer) {
    trailer = `https://www.youtube.com/watch?v=${youTubeTrailer.key}`
  }

  const cast = content.credits.cast.slice(0, 10).map((actor: any) => {
    const person: Person = {
      id: actor.id,
      name: actor.name,
      role: actor.character,
      imageUrl: `https://image.tmdb.org/t/p/original${actor.profile_path}`,
      share_url: `https://cut.watch/person/${actor.id}`
    }
    return person
  })

  const watchProviders = watchProviderMapper(content["watch/providers"].results["US"])

  const crew: Person[] = content.credits.crew.map((c: any) => {
    const person: Person = {
      id: c.id,
      name: c.name,
      imageUrl: `https://image.tmdb.org/t/p/original${c.profile_path}`,
      share_url: `https://cut.watch/person/${c.id}`,
      role: c.job
    };
    return person
  })

  return {
    cast,
    crew,
    overview: content.overview,
    watchProviders,
    userRating: content.vote_average / 10,
  }
}
