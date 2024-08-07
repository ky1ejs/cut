import { ContentType } from "@prisma/client";
import { ExtendedMovie, ProductionCountry, ContentType as GqlContentType } from "../../../__generated__/graphql";
import prisma from "../../../prisma";
import importTmbdContent from "../../../db/tmdbImporter";
import contentDbToGqlMapper, { ResolvedContent, contentInclude } from "../../mappers/contentDbToGqlMapper";
import { DeepPartial } from "utility-types";
import TMDB from "../../../datasources/TMDB";
import extendedContentMapper from "../../mappers/extendedContentMapper";
import ContentID from "../../../types/ContentID";
import Provider from "../../../types/providers";

export default async function movieResolver(id: ContentID, tmdb: TMDB): Promise<DeepPartial<ExtendedMovie>> {
  let movie: ResolvedContent
  let extendedMovie: any
  switch (id.provider) {
    case Provider.TMDB:
      extendedMovie = await tmdb.fetchMovie(id.id);
      movie = await importTmbdContent(extendedMovie, "en", "US", ContentType.MOVIE);
      break;
    default:
      const cutMovie = await prisma.content.findUnique({
        where: { id: id.id },
        include: contentInclude
      });
      if (!cutMovie || !cutMovie.tmdbId) {
        throw new Error(`Movie with id ${id.id} not found`);
      }
      movie = cutMovie;
      extendedMovie = await tmdb.fetchMovie(cutMovie.tmdbId.toString())
  }

  const gqlMovie = contentDbToGqlMapper(movie);

  const productionCountries = extendedMovie.production_countries.map((c: any) => {
    const country: ProductionCountry = {
      name: c.name,
      iso_3166_1: c.iso_3166_1,
      // from https://medium.com/binary-passion/lets-turn-an-iso-country-code-into-a-unicode-emoji-shall-we-870c16e05aad
      emoji: (c.iso_3166_1 as string).toUpperCase().replace(/./g, char => String.fromCodePoint(char.charCodeAt(0) + 127397))
    }
    return country
  })

  const extendedContent = extendedContentMapper(extendedMovie)

  return {
    ...gqlMovie,
    ...extendedContent,
    __typename: "ExtendedMovie",
    runtime: extendedMovie.runtime,
    backdrop_url: `https://image.tmdb.org/t/p/original${extendedMovie.backdrop_path}`,
    productionCountries,
    director: extendedContent.crew.find(c => c.role.toLowerCase() === "director"),
    type: GqlContentType.Movie
  };
}
