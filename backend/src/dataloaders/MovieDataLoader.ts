
import DataLoader from "dataloader";
import prisma from "../prisma";
import { ResolvedMovie, movieInclude } from "../resolvers/mappers/dbMovieToGqlMovie";

export default class MovieDataLoader {
  private batchMovieFetch = new DataLoader<string, ResolvedMovie | undefined>(async (ids) => {
    const movies = await prisma.movie.findMany({
      where: {
        OR: ids.map((id) => ({ id }))
      },
      include: movieInclude
    })
    const keyedMovies = new Map(movies.map(m => [m.id, m]))
    return ids.map(id => keyedMovies.get(id))
  })

  async getMovie(id: string) {
    return this.batchMovieFetch.load(id)
  }
}
