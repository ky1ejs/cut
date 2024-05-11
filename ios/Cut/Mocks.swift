//
//  MovieJson.swift
//  Cut
//
//  Created by Kyle Satti on 2/24/24.
//

import Foundation
import ApolloAPI

struct Mocks {
    static func parse<T: RootSelectionSet>(_ json: String) -> T {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
            return try T(data: jsonObject)
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }

    static var movie: Movie {
        let json = """
            {
                "__typename": "Movie",
                "title": "Breaking Bad",
                "id": "TV_SHOW:TMDB:1396",
                "allIds": [
                  "TV_SHOW:TMDB:1396"
                ],
                "poster_url": "https://image.tmdb.org/t/p/w500/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
                "releaseDate": null,
                "url": "https://cut.watch/movie/1396",
                "type": "TV_SHOW",
                "mainGenre": {
                  "__typename": "Genre",
                  "id": 7,
                  "name": "Drama"
                },
                "genres": [
                  {
                    "__typename": "Genre",
                    "name": "Drama",
                    "id": 7
                  },
                  {
                    "__typename": "Genre",
                    "name": "Crime",
                    "id": 5
                  }
                ],
                "isOnWatchList": false
              }
        """
        return parse(json)
    }

    static var extendedTvShow: CutGraphQL.ExtendedTVShowFragment {
        let json = """
        {
              "__typename": "ExtendedTVShow",
              "title": "Breaking Bad",
              "id": "db97a27e-98eb-4564-9564-31affe67c632",
              "allIds": [
                "db97a27e-98eb-4564-9564-31affe67c632",
                "TMDB:1396"
              ],
              "poster_url": "https://image.tmdb.org/t/p/original/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
              "releaseDate": "2008-01-20T00:00:00.000Z",
              "url": "https://cut.watch/movie/db97a27e-98eb-4564-9564-31affe67c632",
              "mainGenre": {
                "__typename": "Genre",
                "id": 7,
                "name": "Drama"
              },
              "genres": [
                {
                  "__typename": "Genre",
                  "name": "Crime",
                  "id": 5
                },
                {
                  "__typename": "Genre",
                  "name": "Drama",
                  "id": 7
                }
              ],
              "isOnWatchList": false,
              "overview": "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
              "trailerUrl": "https://www.youtube.com/watch?v=XZ8daibM3AE",
              "userRating": 0.89,
              "seasonCount": 5,
              "episodeCount": 62,
              "watchProviders": [
                {
                  "__typename": "WatchProvider",
                  "provider_id": 2,
                  "provider_name": "Apple TV",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/9ghgSC0MA082EL6HLCW3GalykFD.jpg",
                  "accessModels": [
                    "BUY"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 10,
                  "provider_name": "Amazon Video",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/seGSXajazLMCKGB5hnRCidtjay1.jpg",
                  "accessModels": [
                    "BUY"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 3,
                  "provider_name": "Google Play Movies",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg",
                  "accessModels": [
                    "BUY"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 7,
                  "provider_name": "Vudu",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/i6lRmkKmJ23oOZ6IyjnOYLKxA9J.jpg",
                  "accessModels": [
                    "BUY"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 68,
                  "provider_name": "Microsoft Store",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/5vfrJQgNe9UnHVgVNAwZTy0Jo9o.jpg",
                  "accessModels": [
                    "BUY"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 8,
                  "provider_name": "Netflix",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg",
                  "accessModels": [
                    "STREAM"
                  ]
                },
                {
                  "__typename": "WatchProvider",
                  "provider_id": 1796,
                  "provider_name": "Netflix basic with Ads",
                  "link": "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=US",
                  "logo_url": "https://image.tmdb.org/t/p/original/kICQccvOh8AIBMHGkBXJ047xeHN.jpg",
                  "accessModels": [
                    "STREAM"
                  ]
                }
              ],
              "cast": [
                {
                  "__typename": "Actor",
                  "id": "17419",
                  "name": "Bryan Cranston",
                  "profile_url": "https://image.tmdb.org/t/p/original/kNyTXGkiSP8W4Gs60hF7UoxZnWN.jpg",
                  "character": "Walter White"
                },
                {
                  "__typename": "Actor",
                  "id": "84497",
                  "name": "Aaron Paul",
                  "profile_url": "https://image.tmdb.org/t/p/original/8Ac9uuoYwZoYVAIJfRLzzLsGGJn.jpg",
                  "character": "Jesse Pinkman"
                },
                {
                  "__typename": "Actor",
                  "id": "134531",
                  "name": "Anna Gunn",
                  "profile_url": "https://image.tmdb.org/t/p/original/adppyeu1a4REN3khtgmXusrapFi.jpg",
                  "character": "Skyler White"
                },
                {
                  "__typename": "Actor",
                  "id": "14329",
                  "name": "Dean Norris",
                  "profile_url": "https://image.tmdb.org/t/p/original/rHQqo9toD7fgE6HvfJ7oymdY6YO.jpg",
                  "character": "Hank Schrader"
                },
                {
                  "__typename": "Actor",
                  "id": "1217934",
                  "name": "Betsy Brandt",
                  "profile_url": "https://image.tmdb.org/t/p/original/kIbVUpGfLAF1KMn1YvWPnc12DRP.jpg",
                  "character": "Marie Schrader"
                },
                {
                  "__typename": "Actor",
                  "id": "209674",
                  "name": "RJ Mitte",
                  "profile_url": "https://image.tmdb.org/t/p/original/aG6NYV2EgzBFLRIl7vvbtd7go1j.jpg",
                  "character": "Walter White Jr."
                },
                {
                  "__typename": "Actor",
                  "id": "59410",
                  "name": "Bob Odenkirk",
                  "profile_url": "https://image.tmdb.org/t/p/original/rF0Lb6SBhGSTvjRffmlKRSeI3jE.jpg",
                  "character": "Saul Goodman"
                },
                {
                  "__typename": "Actor",
                  "id": "783",
                  "name": "Jonathan Banks",
                  "profile_url": "https://image.tmdb.org/t/p/original/bswk26L13PvY4iMTwUTAsepXCLv.jpg",
                  "character": "Mike Ehrmantraut"
                }
              ],
              "crew": [
                {
                  "__typename": "Person",
                  "id": "29779",
                  "name": "Michelle MacLaren",
                  "profile_url": "https://image.tmdb.org/t/p/original/3LcH5eNiysMWaepARllVrS4Dzn7.jpg",
                  "role": "EXECUTIVE_PRODUCER"
                },
                {
                  "__typename": "Person",
                  "id": "1223202",
                  "name": "Diane Mercer",
                  "profile_url": "https://image.tmdb.org/t/p/originalnull",
                  "role": "PRODUCER"
                },
                {
                  "__typename": "Person",
                  "id": "17419",
                  "name": "Bryan Cranston",
                  "profile_url": "https://image.tmdb.org/t/p/original/kNyTXGkiSP8W4Gs60hF7UoxZnWN.jpg",
                  "role": "PRODUCER"
                },
                {
                  "__typename": "Person",
                  "id": "1223200",
                  "name": "Stewart Lyons",
                  "profile_url": "https://image.tmdb.org/t/p/original/dCAN4EMn8rsqALwDIjf9aNjuVTm.jpg",
                  "role": "PRODUCER"
                },
                {
                  "__typename": "Person",
                  "id": "5162",
                  "name": "Mark Johnson",
                  "profile_url": "https://image.tmdb.org/t/p/original/gLuXkOQjqB81aHMGJ2OtYzEpHQu.jpg",
                  "role": "EXECUTIVE_PRODUCER"
                },
                {
                  "__typename": "Person",
                  "id": "66633",
                  "name": "Vince Gilligan",
                  "profile_url": "https://image.tmdb.org/t/p/original/z3E0DhBg1V1PZVEtS9vfFPzOWYB.jpg",
                  "role": "EXECUTIVE_PRODUCER"
                }
              ],
              "seasons": [
                {
                  "__typename": "Season",
                  "id": "3572",
                  "name": "Season 1",
                  "overview": "High school chemistry teacher Walter White's life is suddenly transformed by a dire medical diagnosis. Street-savvy former student Jesse Pinkman teaches Walter a new trade.",
                  "season_number": 1,
                  "episode_count": 7,
                  "air_date": "2008-01-20T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/1BP4xYv9ZG4ZVHkL7ocOziBbSYH.jpg"
                },
                {
                  "__typename": "Season",
                  "id": "3573",
                  "name": "Season 2",
                  "overview": "Walt must deal with the chain reaction of his choice, as he and Jesse face new and severe consequences. When danger and suspicion around Walt escalate, he is pushed to new levels of desperation. Just how much higher will the stakes rise? How far is Walt willing to go to ensure his family's security? Will his grand plan spiral out of control?",
                  "season_number": 2,
                  "episode_count": 13,
                  "air_date": "2009-03-08T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/e3oGYpoTUhOFK0BJfloru5ZmGV.jpg"
                },
                {
                  "__typename": "Season",
                  "id": "3575",
                  "name": "Season 3",
                  "overview": "Walt continues to battle dueling identities: a desperate husband and father trying to provide for his family, and a newly appointed key player in the Albuquerque drug trade. As the danger around him escalates, Walt is now entrenched in the complex worlds of an angst-ridden family on the verge of dissolution, and the ruthless and unrelenting drug cartel.",
                  "season_number": 3,
                  "episode_count": 13,
                  "air_date": "2010-03-21T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/ffP8Q8ew048YofHRnFVM18B2fPG.jpg"
                },
                {
                  "__typename": "Season",
                  "id": "3576",
                  "name": "Season 4",
                  "overview": "Walt and Jesse must cope with the fallout of their previous actions, both personally and professionally. Tension mounts as Walt faces a true standoff with his employer, Gus, with neither side willing or able to back down. Walt must also adjust to a new relationship with Skyler, whom while still reconciling her relationship with Walt, is committed to properly laundering Walt’s money and ensuring her sister Marie and an ailing Hank are financially stable.",
                  "season_number": 4,
                  "episode_count": 13,
                  "air_date": "2011-07-17T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/5ewrnKp4TboU4hTLT5cWO350mHj.jpg"
                },
                {
                  "__typename": "Season",
                  "id": "3578",
                  "name": "Season 5",
                  "overview": "Walt is faced with the prospect of moving on in a world without his enemy. As the pressure of a criminal life starts to build, Skyler struggles to keep Walt’s terrible secrets. Facing resistance from sometime adversary and former Fring lieutenant Mike, Walt tries to keep his world from falling apart even as his DEA Agent brother in law, Hank, finds numerous leads that could blaze a path straight to Walt. ",
                  "season_number": 5,
                  "episode_count": 16,
                  "air_date": "2012-07-15T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/r3z70vunihrAkjILQKWHX0G2xzO.jpg"
                },
                {
                  "__typename": "Season",
                  "id": "3577",
                  "name": "Specials",
                  "overview": "",
                  "season_number": 0,
                  "episode_count": 9,
                  "air_date": "2009-02-17T00:00:00.000Z",
                  "poster_url": "https://image.tmdb.org/t/p/original/40dT79mDEZwXkQiZNBgSaydQFDP.jpg"
                }
              ]
            }
        """
        return parse(json)
    }

    static var completeAccount: CutGraphQL.CompleteAccountFragment {
        let json = """
        {
              "__typename": "CompleteAccount",
              "username": "kylejs",
              "name": "Kyle Satti",
              "bio": "Co-founder of Cut",
              "bio_url": "https://kylejs.dev",
              "id": "72686e5d-025f-46ef-b78d-a1511fd01383",
              "followerCount": 100,
              "followingCount": 100,
              "share_url": "https://cut.watch/p/fab",
              "watchList": [
                  {
                      "__typename": "Movie",
                      "type": "MOVIE",
                      "title": "Godzilla x Kong: The New Empire",
                      "id": "MOVIE:27f3ad05-5959-4d57-9165-679b0b795722",
                      "allIds": [
                        "MOVIE:27f3ad05-5959-4d57-9165-679b0b795722",
                        "MOVIE:TMDB:823464"
                      ],
                      "poster_url": "https://image.tmdb.org/t/p/original/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
                      "releaseDate": "2024-03-27T00:00:00.000Z",
                      "url": "https://cut.watch/movie/27f3ad05-5959-4d57-9165-679b0b795722",
                      "mainGenre": {
                        "__typename": "Genre",
                        "id": 1,
                        "name": "Action"
                      },
                      "genres": [
                        {
                          "__typename": "Genre",
                          "name": "Action",
                          "id": 1
                        },
                        {
                          "__typename": "Genre",
                          "name": "Adventure",
                          "id": 2
                        },
                        {
                          "__typename": "Genre",
                          "name": "Science Fiction",
                          "id": 15
                        }
                      ],
                      "isOnWatchList": true
                    }
              ],
              "favoriteMovies": [
                  {
                      "__typename": "Movie",
                      "type": "MOVIE",
                      "title": "Godzilla x Kong: The New Empire",
                      "id": "MOVIE:27f3ad05-5959-4d57-9165-679b0b795722",
                      "allIds": [
                        "MOVIE:27f3ad05-5959-4d57-9165-679b0b795722",
                        "MOVIE:TMDB:823464"
                      ],
                      "poster_url": "https://image.tmdb.org/t/p/original/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
                      "releaseDate": "2024-03-27T00:00:00.000Z",
                      "url": "https://cut.watch/movie/27f3ad05-5959-4d57-9165-679b0b795722",
                      "mainGenre": {
                        "__typename": "Genre",
                        "id": 1,
                        "name": "Action"
                      },
                      "genres": [
                        {
                          "__typename": "Genre",
                          "name": "Action",
                          "id": 1
                        },
                        {
                          "__typename": "Genre",
                          "name": "Adventure",
                          "id": 2
                        },
                        {
                          "__typename": "Genre",
                          "name": "Science Fiction",
                          "id": 15
                        }
                      ],
                      "isOnWatchList": false
                    }
              ]
        }
        """
        return parse(json)
    }

    static var profile: CutGraphQL.ProfileFragment {
        let json = """
        {
          "__typename": "CompleteAccount",
          "id": "70ffec09-2416-425b-8794-e7e35cafd1b2",
          "username": "kylejs",
          "name": "Kyle",
          "bio_url": "https://kylejs.dev",
          "share_url": "https://cut.watch/p/kylejs",
          "bio": "Lisan Al-Gaib",
          "imageUrl": null,
          "followerCount": 100,
          "followingCount": 100,
          "phoneNumber": null
        }
        """
        return parse(json)
    }

    static var profileInterface: CutGraphQL.ProfileInterfaceFragment {
        profile.fragments.profileInterfaceFragment
    }

    static var personFragment: CutGraphQL.PersonInterfaceFragment {
        let json = """
        {
            "__typename": "Person",
            "id": "29779",
            "name": "Michelle MacLaren",
            "imageUrl": "https://image.tmdb.org/t/p/original/3LcH5eNiysMWaepARllVrS4Dzn7.jpg",
            "share_url": "https://cut.watch"
        }
        """
        return parse(json)
    }

    static var personWithRoleFragment: CutGraphQL.PersonFragment {
        let json = """
        {
            "__typename": "Person",
            "id": "29779",
            "name": "Michelle MacLaren",
            "imageUrl": "https://image.tmdb.org/t/p/original/3LcH5eNiysMWaepARllVrS4Dzn7.jpg",
            "share_url": "https://cut.watch",
            "role": "PRODUCER"
        }
        """
        return parse(json)
    }
}
