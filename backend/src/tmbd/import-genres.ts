import fs from 'fs';
import axios, { all } from 'axios';
import prisma from '../prisma';
import { Genre, Prisma } from '@prisma/client';

type Country = {
  iso_3166_1: string;
  name: string;
}

type Language = {
  iso_639_1: string;
  name: string;
  default_country: Country;
  countries: Country[];
}

const importGenres = async () => {
  const supportedLangsFile = fs.readFileSync(__dirname + '/../resources/langs.json', 'utf-8');
  const supportedLangs: Language[] = JSON.parse(supportedLangsFile);

  const genreFetcher = new GenreFetcher();

  const allGenres = await prisma.genre.findMany({ where: { tmdbId: { not: null } } });

  for (const lang of supportedLangs) {
    for (const genre of allGenres) {
      await importLanguage(genre, lang.iso_639_1, lang.default_country.iso_3166_1, genreFetcher);
      for (const country of lang.countries) {
        await importLanguage(genre, lang.iso_639_1, country.iso_3166_1, genreFetcher);
      }
    }
  }
}

async function importLanguage(genre: Genre, lang: string, country: string, genreFetcher: GenreFetcher): Promise<void> {
  if (!genre.tmdbId) return;
  const existingTranslationForDetault = await prisma.localizedGenre.findUnique({
    where: {
      genreId_language_ISO_639_1_country_ISO_3166_1: {
        genreId: genre.id,
        language_ISO_639_1: lang,
        country_ISO_3166_1: country
      }
    }
  });
  if (existingTranslationForDetault) return;

  const fetchedGenre = await genreFetcher.fetchGenresForId(genre.tmdbId, lang, country);

  if (!fetchedGenre) return;

  await prisma.localizedGenre.create({
    data: {
      genreId: genre.id,
      language_ISO_639_1: lang,
      country_ISO_3166_1: country,
      name: fetchedGenre.name
    }
  });
}

type TMDbGenre = {
  id: number;
  name: string;
}

class GenreFetcher {
  private existingGenres: Map<string, Map<number, TMDbGenre>> = new Map();

  async fetchGenresForId(id: number, lang: string, country: string): Promise<TMDbGenre | undefined> {
    const key = `${lang}-${country}`;
    const existingGenresForLang = this.existingGenres.get(key);
    if (existingGenresForLang) {
      const genre = existingGenresForLang.get(id);
      if (genre) {
        return genre;
      }
    }

    const url = `https://api.themoviedb.org/3/genre/movie/list?language=${key}`
    const result = await axios.get(url, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`
      }
    })

    const map = new Map<number, TMDbGenre>();
    for (const genre of result.data.genres) {
      map.set(genre.id, genre);
    }
    this.existingGenres.set(key, map);

    return map.get(id);
  }
}

export default importGenres;
