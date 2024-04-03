import { Movie } from "@prisma/client";
import { Actor, Person, PersonRole, ProductionCountry, QueryResolvers, Resolvers, WatchProvider } from "../../__generated__/graphql";
import fetchTmdbMovie from "../../datasources/fetchTmdbMovie";
import prisma from "../../prisma";
import importTmbdMovie from "../../db/tmdbImporter";
import axios from "axios";
import dbMovieToGqlMovie, { ResolvedMovie } from "../mappers/dbMovieToGqlMovie";
import e from "express";

const movieResolver: QueryResolvers["movie"] = async (_, args, context) => {
  let movie: ResolvedMovie
  const [provider, movieId] = args.id.split(':');
  switch (provider) {
    case 'TMDB':
      const tmdbMovie = await fetchTmdbMovie(movieId);
      movie = await importTmbdMovie(tmdbMovie, "en", "US");
      break;
    default:
      const cutMovie = await prisma.movie.findUnique({
        where: {
          id: movieId || provider
        },
        include: {
          images: true,
          mainGenre: {
            include: {
              locales: {
                where: {
                  language_ISO_639_1: "en"
                }
              }
            }
          },
          genres: {
            include: {
              genre: {
                include: {
                  locales: {
                    where: {
                      language_ISO_639_1: "en"
                    }
                  }
                }
              }
            }
          }
        }
      });
      if (!cutMovie) {
        throw new Error(`Movie with id ${movieId} not found`);
      }
      movie = cutMovie;
  }

  const extendedMovieData = await axios.get(
    `https://api.themoviedb.org/3/movie/${movie.tmdbId}?language=en-US&append_to_response=watch%2Fproviders%2Cvideos%2Ccredits`,
    { headers: { Authorization: `Bearer ${process.env.TMDB_API_KEY}` } });

  const gqlMovie = dbMovieToGqlMovie(movie);

  const watchProviders = extendedMovieData.data["watch/providers"].results["US"];
  const buyProviders = watchProviders ? mapProviders(watchProviders.buy, watchProviders.link) : []
  const rentProviders = watchProviders ? mapProviders(watchProviders.rent, watchProviders.link) : []
  const streamProviders = watchProviders ? mapProviders(watchProviders.flatrate, watchProviders.link) : []

  const cast = extendedMovieData.data.credits.cast.slice(0, 10).map((actor: any) => {
    const a: Actor = {
      id: actor.id,
      name: actor.name,
      character: actor.character,
      profile_url: `https://image.tmdb.org/t/p/original${actor.profile_path}`
    }
    return a
  })

  const crew: Person[] = extendedMovieData.data.credits.crew.map((c: any) => {
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
  }).filter((c: any) => c !== null).slice(0, 20)

  const productionCountries = extendedMovieData.data.production_countries.map((c: any) => {
    const country: ProductionCountry = {
      name: c.name,
      iso_3166_1: c.iso_3166_1,
      // from https://medium.com/binary-passion/lets-turn-an-iso-country-code-into-a-unicode-emoji-shall-we-870c16e05aad
      emoji: (c.iso_3166_1 as string).toUpperCase().replace(/./g, char => String.fromCodePoint(char.charCodeAt(0) + 127397))
    }
    return country
  })

  const trailerKey = extendedMovieData.data.videos.results.find((v: any) => v.type === "Trailer" && v.site === "YouTube").key;
  const trailer = `https://www.youtube.com/watch?v=${trailerKey}`

  return {
    ...gqlMovie,
    __typename: "ExtendedMovie",
    overview: extendedMovieData.data.overview,
    runtime: extendedMovieData.data.runtime,
    backdrop_url: `https://image.tmdb.org/t/p/original${extendedMovieData.data.backdrop_path}`,
    watchProviders: {
      buy: buyProviders,
      rent: rentProviders,
      stream: streamProviders
    },
    cast,
    crew,
    userRating: extendedMovieData.data.vote_average / 10,
    productionCountries,
    trailerUrl: trailer,
    director: crew.find(c => c.role === PersonRole.Director),
  };
}

function mapProviders(provider: any, link: any): WatchProvider[] {
  if (!provider) {
    return [];
  }
  const mapProvider = (provider: any) => {
    const p: WatchProvider = {
      provider_id: provider.provider_id,
      provider_name: provider.provider_name,
      link: link,
      logo_url: `https://image.tmdb.org/t/p/original${provider.logo_path}`
    }
    return p
  }
  return provider.map(mapProvider);
}

export default movieResolver;
