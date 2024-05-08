import { AccessModel, WatchProvider } from "../../__generated__/graphql"

export default function watchProviderMapper(watchProviders: any): WatchProvider[] {
  let parsedWatchProviders = new Map<string, WatchProvider>()
  if (watchProviders) {
    const link = watchProviders.link
    const mapProvider = (provider: any, accessModel: AccessModel) => {
      const existingProvider = parsedWatchProviders.get(provider.provider_id)
      if (existingProvider && !existingProvider.accessModels.includes(accessModel)) {
        existingProvider.accessModels.push(accessModel)
      } else if (!existingProvider) {
        parsedWatchProviders.set(provider.provider_id, {
          provider_id: provider.provider_id,
          provider_name: provider.provider_name,
          link: link,
          logo_url: `https://image.tmdb.org/t/p/original${provider.logo_path}`,
          accessModels: [accessModel]
        })
      }
    }
    if (watchProviders.rent) {
      watchProviders.rent.forEach((w: any) => mapProvider(w, AccessModel.Rent))
    }
    if (watchProviders.buy) {
      watchProviders.buy.forEach((w: any) => mapProvider(w, AccessModel.Buy))
    }
    if (watchProviders.flatrate) {
      watchProviders.flatrate.forEach((w: any) => mapProvider(w, AccessModel.Stream))
    }
    Array.from(parsedWatchProviders.values()).forEach(p => {
      p.accessModels.sort((a, b) => a.localeCompare(b))
    });
  }
  return Array.from(parsedWatchProviders.values())
}
