import { QueryResolvers, Work } from "../../__generated__/graphql";
import tmdbMovieToGqlMapper from "../mappers/tmdbMovieToGqlMapper";

const personResolver: QueryResolvers["person"] = async (_, args, { dataSources: { tmdb } }) => {
  const person = await tmdb.fetchPerson(args.id);
  let birthday: Date | null = null
  if (person.birthday) {
    birthday = new Date(person.birthday)
  }
  let deathday: Date | null = null
  if (person.deathday) {
    deathday = new Date(person.deathday)
  }

  let works: Work[] = []
  // only map the first 10 works
  works.push(...person.combined_credits.cast.slice(0, 10).map(async (work: any) => {
    const movie = await tmdbMovieToGqlMapper(work)
    return {
      ...movie,
      role: work.character
    }
  })
  )
  works.push(...person.combined_credits.crew.slice(0, 10).map(async (work: any) => {
    const movie = await tmdbMovieToGqlMapper(work)
    return {
      ...movie,
      role: work.job
    }
  })
  )
  return {
    id: person.id,
    name: person.name,
    imageUrl: `https://image.tmdb.org/t/p/original${person.profile_path}`,
    share_url: `https://www.themoviedb.org/person/${person.id}`,

    biography: person.biography,
    birthday: birthday,
    deathday: deathday,
    placeOfBirth: person.place_of_birth,
    knownFor: person.known_for_department,
    works
  }
}

export default personResolver;
