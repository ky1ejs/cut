import { SeasonPerson, SeasonRole } from "../../__generated__/graphql";

export default function mapSeasonPerson(person: any): SeasonPerson {
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
