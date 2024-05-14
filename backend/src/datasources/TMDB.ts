import axios from 'axios';

export default class TMDB {
  static instance = new TMDB();
  private static BASE_URL = 'https://api.themoviedb.org/3';

  async fetchMovie(id: string) {
    const params = new URLSearchParams({
      append_to_response: 'watch/providers,videos,credits',
      language: 'en-US'
    });
    const endpoint = `${TMDB.BASE_URL}/movie/${id}?${params.toString()}`
    const response = await this.createRequest(endpoint)
    return response.data;
  }

  async fetchTvShow(id: string) {
    const params = new URLSearchParams({
      append_to_response: 'watch/providers,videos,credits',
      language: 'en-US'
    });
    const endpoint = `${TMDB.BASE_URL}/tv/${id}?${params.toString()}`
    const response = await this.createRequest(endpoint)
    return response.data;
  }

  async fetchPerson(id: string) {
    const params = new URLSearchParams({
      append_to_response: 'combined_credits',
      language: 'en-US'
    });
    const endpoint = `${TMDB.BASE_URL}/person/${id}?${params.toString()}`
    const response = await this.createRequest(endpoint)
    return response.data;
  }

  async fetchSeason(id: string, seasonNumber: number) {
    const params = new URLSearchParams({
      append_to_response: 'aggregate_credits',
      language: 'en-US'
    });
    const endpoint = `${TMDB.BASE_URL}/tv/${id}/season/${seasonNumber}?${params.toString()}`
    const response = await this.createRequest(endpoint)
    return response.data;
  }

  private createRequest(endpoint: string) {
    return axios.get(endpoint, {
      headers: {
        Authorization: `Bearer ${process.env.TMDB_API_KEY}`,
        accept: 'application/json',
      }
    });
  }
}