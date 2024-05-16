import { Person } from "../../__generated__/graphql";

export default function mapPerson(c: any): Person {
  return {
    id: c.id,
    name: c.name,
    imageUrl: `https://image.tmdb.org/t/p/original${c.profile_path}`,
    share_url: `https://cut.watch/person/${c.id}`,
    role: c.job || c.character,
  }
}
