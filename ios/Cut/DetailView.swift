//
//  DetailView.swift
//  Cut
//
//  Created by Kyle Satti on 2/23/24.
//

import SwiftUI

func formatTime(minutes: Int) -> String {
    let hours = minutes / 60
    let remainingMinutes = minutes % 60

    if hours == 0 {
        return "\(remainingMinutes)min"
    } else if remainingMinutes == 0 {
        return "\(hours)h"
    } else {
        return "\(hours)h \(remainingMinutes)min"
    }
}

private extension CutGraphQL.ExtendedMovieFragment {
    var subtitle: String {
        "\(mainGenre?.name ?? "_") • 2024 • \(formatTime(minutes: runtime))"
    }
}

struct DetailView: View {
    let movie: Movie
    @State var extendedMovie: CutGraphQL.ExtendedMovieFragment?

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    URLImage(movie.poster_url)
                        .frame(width: 100, height: 150)
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(movie.title).font(.title)
                        if let extendedMovie = extendedMovie {
                            Text(extendedMovie.subtitle)
                        }
                    }
                }
                HStack(spacing: 16) {
                    Spacer()
                    if let em  = extendedMovie {
                        RatingCirlce(rating: em.userRating)
                    }
                    WatchListButton(isOnWatchList: true) {

                    }
                    Spacer()
                }
                Spacer(minLength: 12)
                if let em  = extendedMovie {
                    Text("Directed by \(em.director.name)")
                    if let trailer = em.trailerUrl {
                        Button(action: {
                            UIApplication.shared.open(URL(string: trailer)!)
                        }, label: {
                            Text("Trailer")
                        })
                    }
                }
                Spacer(minLength: 24)
                if let extendedMovie = extendedMovie {
                    Text(extendedMovie.overview).multilineTextAlignment(.center)
                }
                if let extendedMovie = extendedMovie {
                    URLImage(extendedMovie.backdrop_url)
                }
                if let em = extendedMovie {
                    WatchProviderGroup(title: "Stream", watchProviders: em.watchProviders.stream.map { $0.fragments.watchProviderFragment})
                    WatchProviderGroup(title: "Rent", watchProviders: em.watchProviders.rent.map { $0.fragments.watchProviderFragment})
                    WatchProviderGroup(title: "Buy", watchProviders: em.watchProviders.buy.map { $0.fragments.watchProviderFragment})
                }
            }
            if let em = extendedMovie {
                Text("Cast").font(.title)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(Array(em.cast.enumerated()), id: \.offset) { _, c in
                            PersonCard(person: .actor(c.fragments.actorFragment))
                        }
                    }
                }
                Text("Crew").font(.title)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(Array(em.crew.enumerated()), id: \.offset) { _, c in
                            PersonCard(person: .person(c.fragments.personFragment))
                        }
                    }
                }
                if let em = extendedMovie {
                    Text("Filming Locations").font(.title)
                    HStack {
                        ForEach(em.productionCountries, id: \.iso_3166_1) { pc in
                            Text(pc.emoji)
                        }
                    }
                }
            }

        }
        .scrollBounceBehavior(.basedOnSize)
        .task {
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.MovieQuery(movieId: movie.id)) { result in
                guard case .success(let data) = result, let em = data.data?.movie.fragments.extendedMovieFragment else {
                    return
                }
                self.extendedMovie = em
            }
        }
    }
}

struct WatchProviderGroup: View {
    let title: String
    let watchProviders: [WatchProvider]

    var body: some View {
        if (watchProviders.count > 0) {
            VStack(alignment: .leading) {
                Text(title).font(.title)
                WrappingHStack(alignment: .leading) {
                    ForEach(watchProviders, id: \.provider_id) { w in
                        WatchProviderPill(provider: w)
                    }
                }
            }
        }
    }
}

extension CutGraphQL.PersonRole {
    var name: String {
        switch self {
        case .director:
            return "Director"
        case .executiveProducer:
            return "Executive Producer"
        case .producer:
            return "Producer"
        case .writer:
            return "Writer"
        }
    }
}

struct PersonCard: View {
    let person: PersonType

    enum PersonType {
        case actor(CutGraphQL.ActorFragment)
        case person(CutGraphQL.PersonFragment)

        var id: String {
            switch self {
            case .actor(let a): return a.id
            case .person(let p): return p.id
            }
        }

        var name: String {
            switch self {
            case .actor(let a): return a.name
            case .person(let p): return p.name
            }
        }

        var profile_url: String? {
            switch self {
            case .actor(let a): return a.profile_url
            case .person(let p): return p.profile_url
            }
        }
    }

    var body: some View {
        VStack {
            if let url = person.profile_url {
                URLImage(url)
                    .frame(width: 100)
                    .frame(maxHeight: 150)
            } else {
                Text("?")
            }
            Text(person.name)
                .lineLimit(2)
                .frame(maxWidth: 100)
                .multilineTextAlignment(.center)
            switch person {
            case .actor(let a):
                Text(a.character)
                    .lineLimit(2)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.center)
            case .person(let p):
                Text(p.role.value!.name)
                    .lineLimit(2)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

typealias WatchProvider = CutGraphQL.WatchProviderFragment
struct WatchProviderPill: View {
    let provider: WatchProvider

    var body: some View {
        Button(action: {
            UIApplication.shared.open(URL(string: provider.link)!)
        }) {
            HStack {
                URLImage(provider.logo_url)
                    .frame(maxWidth: 30, maxHeight: 30)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                Text(provider.provider_name)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color(uiColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)), lineWidth: 2))
        }
    }
}

extension URLImage {
    init(_ string: String) {
        self.init(url: URL(string: string)!)
    }
}

#Preview {
    DetailView(movie: Mocks.movie)
}
