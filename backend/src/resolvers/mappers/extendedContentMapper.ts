import { ExtendedContent, Actor, Person, PersonRole } from "../../__generated__/graphql";
import watchProviderMapper from "./watchProviderMapper";

export default function extendedContentMapper(content: any): ExtendedContent {
  const youTubeTrailer = content.videos.results.find((v: any) => v.type === "Trailer" && v.site === "YouTube");
  let trailer: string | null = null;
  if (youTubeTrailer) {
    trailer = `https://www.youtube.com/watch?v=${youTubeTrailer.key}`
  }

  const cast = content.credits.cast.slice(0, 10).map((actor: any) => {
    const a: Actor = {
      id: actor.id,
      name: actor.name,
      character: actor.character,
      profile_url: `https://image.tmdb.org/t/p/original${actor.profile_path}`
    }
    return a
  })

  const watchProviders = watchProviderMapper(content["watch/providers"].results["US"])

  const crew: Person[] = content.credits.crew.map((c: any) => {
    let role: PersonRole
    switch (c.job) {
      case "Director":
        role = PersonRole.Director
        break;
      case "Writer":
        role = PersonRole.Writer
        break;
      case "Producer":
        role = PersonRole.Producer
        break;
      case "Executive Producer":
        role = PersonRole.ExecutiveProducer
        break;
      default:
        return null
    }
    const a: Person = {
      id: c.id,
      name: c.name,
      profile_url: `https://image.tmdb.org/t/p/original${c.profile_path}`,
      role: role
    }
    return a
  }).filter((c: any) => c !== null)

  return {
    cast,
    crew,
    overview: content.overview,
    watchProviders,
    userRating: content.vote_average / 10,
  }
}
