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

    static var content: Content {
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
                "isOnWatchList": false,
                "rating": 4
              }
        """
        return parse(json)
    }

    static var extendedTvShow: CutGraphQL.ExtendedTVShowFragment {
        let json = """
        {
                "__typename": "ExtendedTVShow",
                "title": "Breaking Bad",
                "id": "TV_SHOW:db97a27e-98eb-4564-9564-31affe67c632",
                "type": "TV_SHOW",
                "allIds": [
                  "TV_SHOW:db97a27e-98eb-4564-9564-31affe67c632",
                  "TV_SHOW:TMDB:1396"
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
                "cast": [
                  {
                    "__typename": "Person",
                    "id": "17419",
                    "name": "Bryan Cranston",
                    "share_url": "https://cut.watch/person/17419",
                    "role": "Walter White"
                  },
                  {
                    "__typename": "Person",
                    "id": "84497",
                    "name": "Aaron Paul",
                    "share_url": "https://cut.watch/person/84497",
                    "role": "Jesse Pinkman"
                  },
                  {
                    "__typename": "Person",
                    "id": "134531",
                    "name": "Anna Gunn",
                    "share_url": "https://cut.watch/person/134531",
                    "role": "Skyler White"
                  },
                  {
                    "__typename": "Person",
                    "id": "14329",
                    "name": "Dean Norris",
                    "share_url": "https://cut.watch/person/14329",
                    "role": "Hank Schrader"
                  },
                  {
                    "__typename": "Person",
                    "id": "1217934",
                    "name": "Betsy Brandt",
                    "share_url": "https://cut.watch/person/1217934",
                    "role": "Marie Schrader"
                  },
                  {
                    "__typename": "Person",
                    "id": "209674",
                    "name": "RJ Mitte",
                    "share_url": "https://cut.watch/person/209674",
                    "role": "Walter White Jr."
                  },
                  {
                    "__typename": "Person",
                    "id": "59410",
                    "name": "Bob Odenkirk",
                    "share_url": "https://cut.watch/person/59410",
                    "role": "Saul Goodman"
                  },
                  {
                    "__typename": "Person",
                    "id": "783",
                    "name": "Jonathan Banks",
                    "share_url": "https://cut.watch/person/783",
                    "role": "Mike Ehrmantraut"
                  }
                ],
                "crew": [
                  {
                    "__typename": "Person",
                    "id": "1537674",
                    "name": "Jennifer Bryan",
                    "share_url": "https://cut.watch/person/1537674",
                    "role": "Costume Design"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223198",
                    "name": "Moira Walley-Beckett",
                    "share_url": "https://cut.watch/person/1223198",
                    "role": "Supervising Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "103009",
                    "name": "Thomas Schnauz",
                    "share_url": "https://cut.watch/person/103009",
                    "role": "Co-Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223193",
                    "name": "George Mastras",
                    "share_url": "https://cut.watch/person/1223193",
                    "role": "Co-Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "24951",
                    "name": "Peter Gould",
                    "share_url": "https://cut.watch/person/24951",
                    "role": "Co-Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1930718",
                    "name": "Christian Diaz de Bedoya",
                    "share_url": "https://cut.watch/person/1930718",
                    "role": "Location Manager"
                  },
                  {
                    "__typename": "Person",
                    "id": "3970747",
                    "name": "Andrew Ortner",
                    "share_url": "https://cut.watch/person/3970747",
                    "role": "Associate Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "29779",
                    "name": "Michelle MacLaren",
                    "share_url": "https://cut.watch/person/29779",
                    "role": "Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223194",
                    "name": "Sam Catlin",
                    "share_url": "https://cut.watch/person/1223194",
                    "role": "Co-Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223199",
                    "name": "Melissa Bernstein",
                    "share_url": "https://cut.watch/person/1223199",
                    "role": "Co-Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223202",
                    "name": "Diane Mercer",
                    "share_url": "https://cut.watch/person/1223202",
                    "role": "Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "17419",
                    "name": "Bryan Cranston",
                    "share_url": "https://cut.watch/person/17419",
                    "role": "Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "12706",
                    "name": "Mark S. Freeborn",
                    "share_url": "https://cut.watch/person/12706",
                    "role": "Production Design"
                  },
                  {
                    "__typename": "Person",
                    "id": "4065202",
                    "name": "Richard Berry",
                    "share_url": "https://cut.watch/person/4065202",
                    "role": "Thanks"
                  },
                  {
                    "__typename": "Person",
                    "id": "1223200",
                    "name": "Stewart Lyons",
                    "share_url": "https://cut.watch/person/1223200",
                    "role": "Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "1330079",
                    "name": "Bjarne Sletteland",
                    "share_url": "https://cut.watch/person/1330079",
                    "role": "Art Direction"
                  },
                  {
                    "__typename": "Person",
                    "id": "1537675",
                    "name": "Russell Scott",
                    "share_url": "https://cut.watch/person/1537675",
                    "role": "Casting Associate"
                  },
                  {
                    "__typename": "Person",
                    "id": "1537690",
                    "name": "Al Goto",
                    "share_url": "https://cut.watch/person/1537690",
                    "role": "Stunt Coordinator"
                  },
                  {
                    "__typename": "Person",
                    "id": "1537682",
                    "name": "Kurt Nicholas Forshager",
                    "share_url": "https://cut.watch/person/1537682",
                    "role": "Supervising Sound Editor"
                  },
                  {
                    "__typename": "Person",
                    "id": "1069688",
                    "name": "Thomas Golubić",
                    "share_url": "https://cut.watch/person/1069688",
                    "role": "Music Supervisor"
                  },
                  {
                    "__typename": "Person",
                    "id": "959387",
                    "name": "Sherry Thomas",
                    "share_url": "https://cut.watch/person/959387",
                    "role": "Casting"
                  },
                  {
                    "__typename": "Person",
                    "id": "6479",
                    "name": "Sharon Bialy",
                    "share_url": "https://cut.watch/person/6479",
                    "role": "Casting"
                  },
                  {
                    "__typename": "Person",
                    "id": "1280070",
                    "name": "Dave Porter",
                    "share_url": "https://cut.watch/person/1280070",
                    "role": "Original Music Composer"
                  },
                  {
                    "__typename": "Person",
                    "id": "5162",
                    "name": "Mark Johnson",
                    "share_url": "https://cut.watch/person/5162",
                    "role": "Executive Producer"
                  },
                  {
                    "__typename": "Person",
                    "id": "66633",
                    "name": "Vince Gilligan",
                    "share_url": "https://cut.watch/person/66633",
                    "role": "Executive Producer"
                  }
                ],
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
                "userRating": 0.8907999999999999,
                "trailer": {
                  "__typename": "Trailer",
                  "url": "https://www.youtube.com/watch?v=EM12mcTEI88",
                  "thumbnail_url": "https://img.youtube.com/vi/EM12mcTEI88/hqdefault.jpg"
                },
                "seasonCount": 5,
                "episodeCount": 62,
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
            "__typename": "Profile",
            "id": "70ffec09-2416-425b-8794-e7e35cafd1b2",
            "username": "kylejs",
            "name": "Kyle",
            "bio_url": null,
            "share_url": "https://cut.watch/p/kylejs",
            "bio": null,
            "imageUrl": "https://ucarecdn.com/8fa29a48-61f2-49cb-9ce8-4da50cbaf920/-/resize/500x500/-/format/jpeg/profile",
            "followerCount": 0,
            "followingCount": 0,
            "isFollowing": false,
            "isCurrentUser": false
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

    static var personWithRoleFragment: PersonWithRole {
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

    static var extendedPerson: CutGraphQL.ExtendedPersonFragment {
        let json = """
        {
              "__typename": "ExtendedPerson",
              "id": "1136406",
              "name": "Tom Holland",
              "imageUrl": "https://image.tmdb.org/t/p/original/yxYOaalFh8SUwNE5C0wzOwF89Ny.jpg",
              "share_url": "https://www.themoviedb.org/person/1136406",
              "biography": "Thomas Tom Stanley Holland is an English actor and dancer. He is best known for playing Peter Parker / Spider-Man in the Marvel Cinematic Universe and has appeared as the character in six films: Captain America: Civil War (2016), Spider-Man: Homecoming (2017), Avengers: Infinity War (2018), Avengers: Endgame (2019), Spider-Man: Far From Home (2019), and Spider-Man: No Way Home (2021). He is also known for playing the title role in Billy Elliot the Musical at the Victoria Palace Theatre, London, as well as for starring in the 2012 film The Impossible.",
              "birthday": "1996-06-01T00:00:00.000Z",
              "deathday": null,
              "placeOfBirth": "Surrey, England, UK",
              "knownFor": "Acting",
              "works": [
                {
                  "__typename": "Work",
                  "title": "The Impossible",
                  "id": "MOVIE:TMDB:80278",
                  "allIds": [
                    "MOVIE:TMDB:80278"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/1kBYwWu24QKf47mumWEIAzo5tIu.jpg",
                  "releaseDate": "2012-09-09T00:00:00.000Z",
                  "url": "https://cut.watch/movie/80278",
                  "type": "MOVIE",
                  "mainGenre": {
                    "__typename": "Genre",
                    "id": 2,
                    "name": "Adventure"
                  },
                  "genres": [
                    {
                      "__typename": "Genre",
                      "name": "Adventure",
                      "id": 2
                    },
                    {
                      "__typename": "Genre",
                      "name": "Drama",
                      "id": 7
                    },
                    {
                      "__typename": "Genre",
                      "name": "Thriller",
                      "id": 17
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Lucas Bennett"
                },
                {
                  "__typename": "Work",
                  "title": "How I Live Now",
                  "id": "MOVIE:TMDB:162215",
                  "allIds": [
                    "MOVIE:TMDB:162215"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/4FyDHVuuiy6XObYLyXxFUb4oX8J.jpg",
                  "releaseDate": "2013-09-10T00:00:00.000Z",
                  "url": "https://cut.watch/movie/162215",
                  "type": "MOVIE",
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
                      "name": "Action",
                      "id": 1
                    },
                    {
                      "__typename": "Genre",
                      "name": "Thriller",
                      "id": 17
                    },
                    {
                      "__typename": "Genre",
                      "name": "War",
                      "id": 18
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Isaac"
                },
                {
                  "__typename": "Work",
                  "title": "Locke",
                  "id": "MOVIE:TMDB:210479",
                  "allIds": [
                    "MOVIE:TMDB:210479"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/mZTMFDk5VRQuvkJaCFFAXFV65G6.jpg",
                  "releaseDate": "2014-04-10T00:00:00.000Z",
                  "url": "https://cut.watch/movie/210479",
                  "type": "MOVIE",
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
                      "name": "Thriller",
                      "id": 17
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Eddie (voice)"
                },
                {
                  "__typename": "Work",
                  "title": "Captain America: Civil War",
                  "id": "MOVIE:TMDB:271110",
                  "allIds": [
                    "MOVIE:TMDB:271110"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/rAGiXaUfPzY7CDEyNKUofk3Kw2e.jpg",
                  "releaseDate": "2016-04-27T00:00:00.000Z",
                  "url": "https://cut.watch/movie/271110",
                  "type": "MOVIE",
                  "mainGenre": {
                    "__typename": "Genre",
                    "id": 2,
                    "name": "Adventure"
                  },
                  "genres": [
                    {
                      "__typename": "Genre",
                      "name": "Adventure",
                      "id": 2
                    },
                    {
                      "__typename": "Genre",
                      "name": "Action",
                      "id": 1
                    },
                    {
                      "__typename": "Genre",
                      "name": "Science Fiction",
                      "id": 15
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Peter Parker / Spider-Man"
                },
                {
                  "__typename": "Work",
                  "title": "Spider-Man: Homecoming",
                  "id": "MOVIE:TMDB:315635",
                  "allIds": [
                    "MOVIE:TMDB:315635"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/c24sv2weTHPsmDa7jEMN0m2P3RT.jpg",
                  "releaseDate": "2017-07-05T00:00:00.000Z",
                  "url": "https://cut.watch/movie/315635",
                  "type": "MOVIE",
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
                    },
                    {
                      "__typename": "Genre",
                      "name": "Drama",
                      "id": 7
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Peter Parker / Spider-Man"
                },
                {
                  "__typename": "Work",
                  "title": "In the Heart of the Sea",
                  "id": "MOVIE:TMDB:205775",
                  "allIds": [
                    "MOVIE:TMDB:205775"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/weVvNPfk6FM9vBg3BXtRtNAmiYM.jpg",
                  "releaseDate": "2015-12-03T00:00:00.000Z",
                  "url": "https://cut.watch/movie/205775",
                  "type": "MOVIE",
                  "mainGenre": {
                    "__typename": "Genre",
                    "id": 17,
                    "name": "Thriller"
                  },
                  "genres": [
                    {
                      "__typename": "Genre",
                      "name": "Thriller",
                      "id": 17
                    },
                    {
                      "__typename": "Genre",
                      "name": "Drama",
                      "id": 7
                    },
                    {
                      "__typename": "Genre",
                      "name": "Adventure",
                      "id": 2
                    },
                    {
                      "__typename": "Genre",
                      "name": "Action",
                      "id": 1
                    },
                    {
                      "__typename": "Genre",
                      "name": "History",
                      "id": 10
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Young Thomas Nickerson"
                },
                {
                  "__typename": "Work",
                  "title": "Edge of Winter",
                  "id": "MOVIE:TMDB:402446",
                  "allIds": [
                    "MOVIE:TMDB:402446"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/6SyQ9ebUm90yPrIfQtIKvrFwxnj.jpg",
                  "releaseDate": "2016-07-31T00:00:00.000Z",
                  "url": "https://cut.watch/movie/402446",
                  "type": "MOVIE",
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
                      "name": "Thriller",
                      "id": 17
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Bradley Baker"
                },
                {
                  "__typename": "Work",
                  "title": "The Lost City of Z",
                  "id": "MOVIE:TMDB:314095",
                  "allIds": [
                    "MOVIE:TMDB:314095"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/ik3ebv7J18fs6cHkmu91oxz7EGt.jpg",
                  "releaseDate": "2017-03-15T00:00:00.000Z",
                  "url": "https://cut.watch/movie/314095",
                  "type": "MOVIE",
                  "mainGenre": {
                    "__typename": "Genre",
                    "id": 2,
                    "name": "Adventure"
                  },
                  "genres": [
                    {
                      "__typename": "Genre",
                      "name": "Adventure",
                      "id": 2
                    },
                    {
                      "__typename": "Genre",
                      "name": "Drama",
                      "id": 7
                    },
                    {
                      "__typename": "Genre",
                      "name": "History",
                      "id": 10
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Jack Fawcett"
                },
                {
                  "__typename": "Work",
                  "title": "The Current War",
                  "id": "MOVIE:TMDB:418879",
                  "allIds": [
                    "MOVIE:TMDB:418879"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/eqTjO8yTaPRSKWj7i6Qnr7R5cls.jpg",
                  "releaseDate": "2018-02-01T00:00:00.000Z",
                  "url": "https://cut.watch/movie/418879",
                  "type": "MOVIE",
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
                      "name": "History",
                      "id": 10
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Samuel Insull"
                },
                {
                  "__typename": "Work",
                  "title": "Chaos Walking",
                  "id": "MOVIE:TMDB:412656",
                  "allIds": [
                    "MOVIE:TMDB:412656"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/6FzOcNh6hdn9MNsuqpR6o9jCucM.jpg",
                  "releaseDate": "2021-02-24T00:00:00.000Z",
                  "url": "https://cut.watch/movie/412656",
                  "type": "MOVIE",
                  "mainGenre": {
                    "__typename": "Genre",
                    "id": 9,
                    "name": "Fantasy"
                  },
                  "genres": [
                    {
                      "__typename": "Genre",
                      "name": "Fantasy",
                      "id": 9
                    },
                    {
                      "__typename": "Genre",
                      "name": "Science Fiction",
                      "id": 15
                    },
                    {
                      "__typename": "Genre",
                      "name": "Adventure",
                      "id": 2
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Todd Hewitt"
                },
                {
                  "__typename": "Work",
                  "title": "A Monster Calls",
                  "id": "MOVIE:TMDB:258230",
                  "allIds": [
                    "MOVIE:TMDB:258230"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/vNzWJwVqjszWwXrA7ZfsrJmhgV9.jpg",
                  "releaseDate": "2016-10-07T00:00:00.000Z",
                  "url": "https://cut.watch/movie/258230",
                  "type": "MOVIE",
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
                      "name": "Fantasy",
                      "id": 9
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Stand In"
                },
                {
                  "__typename": "Work",
                  "title": "Uncharted",
                  "id": "MOVIE:TMDB:335787",
                  "allIds": [
                    "MOVIE:TMDB:335787"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/rJHC1RUORuUhtfNb4Npclx0xnOf.jpg",
                  "releaseDate": "2022-02-10T00:00:00.000Z",
                  "url": "https://cut.watch/movie/335787",
                  "type": "MOVIE",
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
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Executive Producer"
                },
                {
                  "__typename": "Work",
                  "title": "Bunny Army",
                  "id": "MOVIE:TMDB:960397",
                  "allIds": [
                    "MOVIE:TMDB:960397"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500null",
                  "releaseDate": null,
                  "url": "https://cut.watch/movie/960397",
                  "type": "MOVIE",
                  "mainGenre": null,
                  "genres": [],
                  "isOnWatchList": false,
                  "role": "Set Decorating Coordinator"
                },
                {
                  "__typename": "Work",
                  "title": "The Crowded Room",
                  "id": "TV_SHOW:TMDB:123192",
                  "allIds": [
                    "TV_SHOW:TMDB:123192"
                  ],
                  "poster_url": "https://image.tmdb.org/t/p/w500/vRmopCFp0j1eJGbILLsYsYzxmL8.jpg",
                  "releaseDate": "2023-06-08T00:00:00.000Z",
                  "url": "https://cut.watch/movie/123192",
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
                    },
                    {
                      "__typename": "Genre",
                      "name": "Mystery",
                      "id": 13
                    }
                  ],
                  "isOnWatchList": false,
                  "role": "Executive Producer"
                }
              ]
            }
        """
        return parse(json)
    }

    static var season: CutGraphQL.SeasonFragment {
        let json = """
        {
            "__typename": "ExtendedSeason",
            "id": "3572",
            "name": "Season 1",
            "overview": "High school chemistry teacher Walter White's life is suddenly transformed by a dire medical diagnosis. Street-savvy former student Jesse Pinkman teaches Walter a new trade.",
            "season_number": 1,
            "episode_count": 7,
            "air_date": "2008-01-20T00:00:00.000Z",
            "poster_url": "https://image.tmdb.org/t/p/original/1BP4xYv9ZG4ZVHkL7ocOziBbSYH.jpg"
          }
        """
        return parse(json)
    }

    static var extendedSeason: CutGraphQL.ExtendedSeasonFragment {
        let json = """
        {
              "__typename": "ExtendedSeason",
              "id": "3572",
              "name": "Season 1",
              "overview": "High school chemistry teacher Walter White's life is suddenly transformed by a dire medical diagnosis. Street-savvy former student Jesse Pinkman teaches Walter a new trade.",
              "season_number": 1,
              "episode_count": 7,
              "air_date": "2008-01-20T00:00:00.000Z",
              "poster_url": "https://image.tmdb.org/t/p/original/1BP4xYv9ZG4ZVHkL7ocOziBbSYH.jpg",
              "cast": [
                {
                  "__typename": "SeasonPerson",
                  "id": "17419",
                  "name": "Bryan Cranston",
                  "imageUrl": "https://image.tmdb.org/t/p/original/kNyTXGkiSP8W4Gs60hF7UoxZnWN.jpg",
                  "share_url": "https://cut.watch/person/17419",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542282760ee313280017f9",
                      "role": "Walter White",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "84497",
                  "name": "Aaron Paul",
                  "imageUrl": "https://image.tmdb.org/t/p/original/8Ac9uuoYwZoYVAIJfRLzzLsGGJn.jpg",
                  "share_url": "https://cut.watch/person/84497",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542282760ee31328001845",
                      "role": "Jesse Pinkman",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "134531",
                  "name": "Anna Gunn",
                  "imageUrl": "https://image.tmdb.org/t/p/original/adppyeu1a4REN3khtgmXusrapFi.jpg",
                  "share_url": "https://cut.watch/person/134531",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542282760ee3132800181b",
                      "role": "Skyler White",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "14329",
                  "name": "Dean Norris",
                  "imageUrl": "https://image.tmdb.org/t/p/original/rHQqo9toD7fgE6HvfJ7oymdY6YO.jpg",
                  "share_url": "https://cut.watch/person/14329",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542283760ee3132800187b",
                      "role": "Hank Schrader",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1217934",
                  "name": "Betsy Brandt",
                  "imageUrl": "https://image.tmdb.org/t/p/original/kIbVUpGfLAF1KMn1YvWPnc12DRP.jpg",
                  "share_url": "https://cut.watch/person/1217934",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542283760ee31328001891",
                      "role": "Marie Schrader",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "209674",
                  "name": "RJ Mitte",
                  "imageUrl": "https://image.tmdb.org/t/p/original/aG6NYV2EgzBFLRIl7vvbtd7go1j.jpg",
                  "share_url": "https://cut.watch/person/209674",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542284760ee313280018a9",
                      "role": "Walter White Jr.",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "61535",
                  "name": "Steven Michael Quezada",
                  "imageUrl": "https://image.tmdb.org/t/p/original/pVYrDkwI6GWvCNL2kJhpDJfBFyd.jpg",
                  "share_url": "https://cut.watch/person/61535",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5271b489760ee35b3e0881a7",
                      "role": "Steven Gomez",
                      "episodeCount": 4
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "115688",
                  "name": "Carmen Serano",
                  "imageUrl": "https://image.tmdb.org/t/p/original/nzJEe2UqvvMIBJZP1aeFEj4EunN.jpg",
                  "share_url": "https://cut.watch/person/115688",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542273760ee31328000676",
                      "role": "Carmen Molina",
                      "episodeCount": 4
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1046460",
                  "name": "Max Arciniega",
                  "imageUrl": "https://image.tmdb.org/t/p/original/eqKAJKPpt41KpsLIkkBnAY4HMAL.jpg",
                  "share_url": "https://cut.watch/person/1046460",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52725845760ee3046b09426e",
                      "role": "Krazy-8",
                      "episodeCount": 3
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "53255",
                  "name": "Cesar Garcia",
                  "imageUrl": "https://image.tmdb.org/t/p/original/ry4IVQM4n3v7Br9S6AibYKar1Dy.jpg",
                  "share_url": "https://cut.watch/person/53255",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527447ca760ee356ea08e165",
                      "role": "No-Doze",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1260529",
                  "name": "Jesus Jr.",
                  "imageUrl": "https://image.tmdb.org/t/p/original/g9FFHKY95LLALg7DuqeX6akAJSG.jpg",
                  "share_url": "https://cut.watch/person/1260529",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527447b3760ee3571308a638",
                      "role": "Gonzo",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "79211",
                  "name": "David House",
                  "imageUrl": "https://image.tmdb.org/t/p/original/t67HnLsCMecFLMdhtJQbkiQiyXq.jpg",
                  "share_url": "https://cut.watch/person/79211",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5271b65b760ee35b0c090f74",
                      "role": "Dr. Delcavoli",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "14984",
                  "name": "Jessica Hecht",
                  "imageUrl": "https://image.tmdb.org/t/p/original/5JVd1ZLnhdZVFInDy8Zut9M1M5C.jpg",
                  "share_url": "https://cut.watch/person/14984",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542275760ee31328000768",
                      "role": "Gretchen Schwartz",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "82945",
                  "name": "Charles Baker",
                  "imageUrl": "https://image.tmdb.org/t/p/original/mhSoY1plaop5eufoHDP4fkIGUfh.jpg",
                  "share_url": "https://cut.watch/person/82945",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744007760ee356f6076365",
                      "role": "Skinny Pete",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "58650",
                  "name": "Raymond Cruz",
                  "imageUrl": "https://image.tmdb.org/t/p/original/ndhc53yEQeeFn01QoOxtPa6GroU.jpg",
                  "share_url": "https://cut.watch/person/58650",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5254227b760ee31328000cd6",
                      "role": "Tuco Salamanca",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670897",
                  "name": "Jason Byrd",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670897",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a655f4b73007faa4261",
                      "role": "Chemistry Student",
                      "episodeCount": 1
                    },
                    {
                      "__typename": "SeasonRole",
                      "id": "63012d2111c066007cbc37b1",
                      "role": "Ben",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "92495",
                  "name": "John Koyama",
                  "imageUrl": "https://image.tmdb.org/t/p/original/AwtHbt8qO7D3EFonG5lqml8xgwb.jpg",
                  "share_url": "https://cut.watch/person/92495",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "631aff1f62f335007ed32cb3",
                      "role": "Emilio Koyama",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1216132",
                  "name": "Aaron Hill",
                  "imageUrl": "https://image.tmdb.org/t/p/original/rNp31SeoVqSQU6OZWxZUhGwAgyq.jpg",
                  "share_url": "https://cut.watch/person/1216132",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542275760ee313280006b4",
                      "role": "Jock",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "161591",
                  "name": "Gregory Chase",
                  "imageUrl": "https://image.tmdb.org/t/p/original/gNdodev00CROpXuAh5EFmkWTVOo.jpg",
                  "share_url": "https://cut.watch/person/161591",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52725cb1760ee3044d0b9984",
                      "role": "Dr. Belknap",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1215836",
                  "name": "Kyle Bornheimer",
                  "imageUrl": "https://image.tmdb.org/t/p/original/79KUwXqB2FdKqxsAMppkJ8Aa78e.jpg",
                  "share_url": "https://cut.watch/person/1215836",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52743e4d760ee35a69055194",
                      "role": "Ken Wins",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "220118",
                  "name": "Benjamin Petry",
                  "imageUrl": "https://image.tmdb.org/t/p/original/xoCIpS2wG2JiP1BXL2qTun8q85o.jpg",
                  "share_url": "https://cut.watch/person/220118",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527442eb760ee3572b078715",
                      "role": "Jake Pinkman",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "202830",
                  "name": "William Sterchi",
                  "imageUrl": "https://image.tmdb.org/t/p/original/6Pbp5BWDPZ7NhkcnjTkUhKEx3QU.jpg",
                  "share_url": "https://cut.watch/person/202830",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527445a9760ee356ff077e53",
                      "role": "Manager",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "210056",
                  "name": "Pierre Barrera",
                  "imageUrl": "https://image.tmdb.org/t/p/original/4JHYsaULy3LwSHig94olNyuYkx5.jpg",
                  "share_url": "https://cut.watch/person/210056",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744776760ee356ea0892f3",
                      "role": "Hugo Archuleta",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "59303",
                  "name": "Marc Mouchet",
                  "imageUrl": "https://image.tmdb.org/t/p/original/8RRgHjKnTnRnhwbUTFn1V6vvc2S.jpg",
                  "share_url": "https://cut.watch/person/59303",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527445f5760ee357130849b9",
                      "role": "Farley",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "187505",
                  "name": "Vivian Nesbitt",
                  "imageUrl": "https://image.tmdb.org/t/p/original/9ox3VUolTMVCvHHsxkY2DfGPRFa.jpg",
                  "share_url": "https://cut.watch/person/187505",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527447f4760ee37c3e00f81f",
                      "role": "Mrs. Pope",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1089016",
                  "name": "Seri DeYoung",
                  "imageUrl": "https://image.tmdb.org/t/p/original/nS0I9N5LOb8TmH4kIa7tIgpIy2z.jpg",
                  "share_url": "https://cut.watch/person/1089016",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744908760ee35a690730ed",
                      "role": "Student",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "967071",
                  "name": "Beth Bailey",
                  "imageUrl": "https://image.tmdb.org/t/p/original/eoedvwzfma84LRwfCYhkb69wky7.jpg",
                  "share_url": "https://cut.watch/person/967071",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744bd7760ee356ff08c286",
                      "role": "Realtor",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1221121",
                  "name": "Dennis Keiffer",
                  "imageUrl": "https://image.tmdb.org/t/p/original/jb6FR0OZgCqbPOkKq2KikXr31WW.jpg",
                  "share_url": "https://cut.watch/person/1221121",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744a4a760ee35a69077c8c",
                      "role": "Lookout",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "58651",
                  "name": "Geoffrey Rivas",
                  "imageUrl": "https://image.tmdb.org/t/p/original/nUDNZ8X0zaaQMd7yejnJNIKb8EY.jpg",
                  "share_url": "https://cut.watch/person/58651",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744c32760ee37c3e01cba4",
                      "role": "Police Officer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "210154",
                  "name": "Mike Miller",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/210154",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744cd0760ee357130a126e",
                      "role": "Jewelry Store Owner",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "210057",
                  "name": "Judith Rane",
                  "imageUrl": "https://image.tmdb.org/t/p/original/yY8fuyFCaXSjBRtDXaF178AwVqq.jpg",
                  "share_url": "https://cut.watch/person/210057",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744834760ee37c3e010cc7",
                      "role": "Office Manager",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "95195",
                  "name": "Michael Bofshever",
                  "imageUrl": "https://image.tmdb.org/t/p/original/mor6lnag6qF5vovOMU2evixanzM.jpg",
                  "share_url": "https://cut.watch/person/95195",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527440ce760ee3570906ada3",
                      "role": "Mr. Pinkman",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223197",
                  "name": "Marius Stan",
                  "imageUrl": "https://image.tmdb.org/t/p/original/14Yc0bTgitXxV0XLPCi944UU1ry.jpg",
                  "share_url": "https://cut.watch/person/1223197",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5272587a760ee3045009ddec",
                      "role": "Bogdan Wolynetz",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223192",
                  "name": "Roberta Marquez Seret",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1223192",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "56846abbc3a36836280008d4",
                      "role": "Chad's Girlfriend",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "209680",
                  "name": "Frederic Doss",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/209680",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "54e89b13c3a36836e0001dc9",
                      "role": "Off Duty Cop",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "191202",
                  "name": "Matt Jones",
                  "imageUrl": "https://image.tmdb.org/t/p/original/uRLrrPJ5eKXIpJBwSJizezUZd4G.jpg",
                  "share_url": "https://cut.watch/person/191202",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52744535760ee3572209100e",
                      "role": "Badger",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "23429",
                  "name": "Adam Godley",
                  "imageUrl": "https://image.tmdb.org/t/p/original/xOM0zOb2KZ2q8M6lRrDo9bEBeJE.jpg",
                  "share_url": "https://cut.watch/person/23429",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "527444c1760ee3572208fbc2",
                      "role": "Elliott Schwartz",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3471782",
                  "name": "Rodney Rush",
                  "imageUrl": "https://image.tmdb.org/t/p/original/vJiq3Gf1L7XEDJuaLkS2Doma4wm.jpg",
                  "share_url": "https://cut.watch/person/3471782",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "62361a15db4ed60045128de2",
                      "role": "Combo",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "41249",
                  "name": "Tess Harper",
                  "imageUrl": "https://image.tmdb.org/t/p/original/8Z770Kk13MK1NP7skWmTxvRGx3V.jpg",
                  "share_url": "https://cut.watch/person/41249",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542277760ee31328000a61",
                      "role": "Mrs. Pinkman",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670896",
                  "name": "Evan Bobrick",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670896",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a1a33a376007a442d63",
                      "role": "Chad",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "36135",
                  "name": "Christopher Dempsey",
                  "imageUrl": "https://image.tmdb.org/t/p/original/pTngvks30p74j40TaniMkg4tbhn.jpg",
                  "share_url": "https://cut.watch/person/36135",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a3d97eab4007d00192b",
                      "role": "E.M.T",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "2969089",
                  "name": "Allan Pacheco",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/2969089",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a5c33a376007f87247b",
                      "role": "Irving",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "219124",
                  "name": "Linda Speciale",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/219124",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a7e33a376007f872481",
                      "role": "Sexy Neighbor",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3212534",
                  "name": "Jesús Ramírez",
                  "imageUrl": "https://image.tmdb.org/t/p/original/1EfPZxdFNNi3LFLR9laLcVROAko.jpg",
                  "share_url": "https://cut.watch/person/3212534",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012a8bfb5299007d660bc8",
                      "role": "Jock's Friend #1",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670906",
                  "name": "Joshua S. Patton",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670906",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012ac4c2f44b007d249b54",
                      "role": "Jock's Friend #2",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1448105",
                  "name": "Shane Marinson",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1448105",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012c9c5f4b73008267ba53",
                      "role": "Ob-Gyn",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670933",
                  "name": "Anthony Wamego",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670933",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012d2abb2602007ceea8d2",
                      "role": "Backhoe Operator",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "939366",
                  "name": "Anna Felix",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/939366",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012e36dfe31d0080103f2c",
                      "role": "Sales Girl",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "2085663",
                  "name": "Daniel Serrano",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/2085663",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012e72426ae8007a5b6b5a",
                      "role": "Meth Drug Dealer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1673624",
                  "name": "Jon Kristian Moore",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1673624",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012ebb426ae800823a6bac",
                      "role": "DEA Agent",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1302829",
                  "name": "Tish Rayburn-Miller",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1302829",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012ec897eab40082b1a672",
                      "role": "Bank Teller",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "2430293",
                  "name": "Kiira Arai",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/2430293",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012f961da7a6007db08d8a",
                      "role": "Server",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "92756",
                  "name": "Bill Allen",
                  "imageUrl": "https://image.tmdb.org/t/p/original/uLMRXLS5kDMr9W1LzJBp5lOnSJD.jpg",
                  "share_url": "https://cut.watch/person/92756",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012fa39653f6007fee8185",
                      "role": "Scientist",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "193285",
                  "name": "Loren Haynes",
                  "imageUrl": "https://image.tmdb.org/t/p/original/1wGpIMPHzx9lEZa2PkLfZ0Y6PXn.jpg",
                  "share_url": "https://cut.watch/person/193285",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012fc4839d93007e4c2dbf",
                      "role": "Music Producer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670958",
                  "name": "Kyle Swimmer",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670958",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012fd111c066007f8de38f",
                      "role": "Louis",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670960",
                  "name": "Robert Arrington",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670960",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012fd93e6f2b0082b3ba66",
                      "role": "Soren",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3670961",
                  "name": "Juanita Trad",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3670961",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "63012fe5839d93007b62c31e",
                      "role": "Medical Technician",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1803314",
                  "name": "Lorri Oliver",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1803314",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b920097c4900911058ab",
                      "role": "Concerned Parent",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3671381",
                  "name": "Kristen Loree",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3671381",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b927532acb007bd3b1cf",
                      "role": "Concerned Parent",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "79236",
                  "name": "Dave Colon",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/79236",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b930532acb007bd3b1d4",
                      "role": "Concerned Parent",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "209844",
                  "name": "Carrie Fleming",
                  "imageUrl": "https://image.tmdb.org/t/p/original/sa8ey6b8wTFYhm170tE7pPWS1An.jpg",
                  "share_url": "https://cut.watch/person/209844",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b987fb5299007d66336f",
                      "role": "Yuppie Woman",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1094319",
                  "name": "Matthew Page",
                  "imageUrl": "https://image.tmdb.org/t/p/original/vMI1zxybJONZYqL8MI9gGxyfqfC.jpg",
                  "share_url": "https://cut.watch/person/1094319",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b9db839d93008b6133ea",
                      "role": "Chemical Plant Guard",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1847290",
                  "name": "Jacob O'Brien Mulliken",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1847290",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301b9f1839d93007b62e5e1",
                      "role": "Prospective Buyer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "3671392",
                  "name": "Charles Dowdy III",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/3671392",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6301ba0f097c490091105904",
                      "role": "Mr. Wilson",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1834391",
                  "name": "Julia Minesci",
                  "imageUrl": "https://image.tmdb.org/t/p/original/gnaYzsPxBlevEzeH4nUTdWFTuCa.jpg",
                  "share_url": "https://cut.watch/person/1834391",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64426b0ee2bca804df435597",
                      "role": "Meth Whore",
                      "episodeCount": 1
                    }
                  ]
                }
              ],
              "crew": [
                {
                  "__typename": "SeasonPerson",
                  "id": "21640",
                  "name": "Robb Wilson King",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/21640",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7020b19c295223b0a46e8",
                      "role": "Production Design",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1018092",
                  "name": "James F. Oberlander",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1018092",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "62feade5cf4a640080998241",
                      "role": "Art Direction",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "17948",
                  "name": "Reynaldo Villalobos",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/17948",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7049c19c2953b63015013",
                      "role": "Director of Photography",
                      "episodeCount": 6
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "2483",
                  "name": "John Toll",
                  "imageUrl": "https://image.tmdb.org/t/p/original/cfL9A6tC7L5Ps5fq1o3WpVKGMb1.jpg",
                  "share_url": "https://cut.watch/person/2483",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7029219c29533d00dd2c1",
                      "role": "Director of Photography",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "35583",
                  "name": "Kathleen Detoro",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/35583",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7034f19c2955402184de6",
                      "role": "Costume Design",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "4065206",
                  "name": "Martin Chávez",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/4065206",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64634bf20f365501190773a4",
                      "role": "Thanks",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1537690",
                  "name": "Al Goto",
                  "imageUrl": "https://image.tmdb.org/t/p/original/sJEtjLwLdqhY3soar4BflPBDpZu.jpg",
                  "share_url": "https://cut.watch/person/1537690",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6450485343501100ea397cba",
                      "role": "Stunt Coordinator",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "111338",
                  "name": "Adam Bernstein",
                  "imageUrl": "https://image.tmdb.org/t/p/original/jtU4MFHJ1KBbMj77yhJ4Od3tpIr.jpg",
                  "share_url": "https://cut.watch/person/111338",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542275760ee31328000725",
                      "role": "Director",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "15858",
                  "name": "Tim Hunter",
                  "imageUrl": "https://image.tmdb.org/t/p/original/n03G1gCKqxpi6udwINygNiLoGdn.jpg",
                  "share_url": "https://cut.watch/person/15858",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5254227b760ee31328000d0c",
                      "role": "Director",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "18320",
                  "name": "Bronwen Hughes",
                  "imageUrl": "https://image.tmdb.org/t/p/original/6m7XiXVXyEaN81e4OyDfWxBpNov.jpg",
                  "share_url": "https://cut.watch/person/18320",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542279760ee31328000b61",
                      "role": "Director",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "205639",
                  "name": "Jim McKay",
                  "imageUrl": "https://image.tmdb.org/t/p/original/hrrBk9T8Ds0UH9NKds1gkbJioTo.jpg",
                  "share_url": "https://cut.watch/person/205639",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542278760ee31328000a9b",
                      "role": "Director",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "66633",
                  "name": "Vince Gilligan",
                  "imageUrl": "https://image.tmdb.org/t/p/original/z3E0DhBg1V1PZVEtS9vfFPzOWYB.jpg",
                  "share_url": "https://cut.watch/person/66633",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542275760ee313280006e8",
                      "role": "Director",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1215145",
                  "name": "Tricia Brock",
                  "imageUrl": "https://image.tmdb.org/t/p/original/5OV41AzetM5WrJ0zKqmw4mShEk5.jpg",
                  "share_url": "https://cut.watch/person/1215145",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5603c49292514122c00042fc",
                      "role": "Director",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1280071",
                  "name": "Lynne Willingham",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1280071",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b702ea19c2955402183a66",
                      "role": "Editor",
                      "episodeCount": 4
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1280074",
                  "name": "Kelley Dixon",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1280074",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7051619c29533d00e8c79",
                      "role": "Editor",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1123195",
                  "name": "Skip Macdonald",
                  "imageUrl": "https://image.tmdb.org/t/p/original/58Ol4VqSnD8NIp9kpi4NkFEh9RF.jpg",
                  "share_url": "https://cut.watch/person/1123195",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b705e619c2955a1f0c895b",
                      "role": "Editor",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "66633",
                  "name": "Vince Gilligan",
                  "imageUrl": "https://image.tmdb.org/t/p/original/z3E0DhBg1V1PZVEtS9vfFPzOWYB.jpg",
                  "share_url": "https://cut.watch/person/66633",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542287760ee31328001af1",
                      "role": "Executive Producer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223201",
                  "name": "Karen Moore",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1223201",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "5254228c760ee31328001c37",
                      "role": "Producer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223200",
                  "name": "Stewart Lyons",
                  "imageUrl": "https://image.tmdb.org/t/p/original/dCAN4EMn8rsqALwDIjf9aNjuVTm.jpg",
                  "share_url": "https://cut.watch/person/1223200",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64189cd9e74146007c82fbfc",
                      "role": "Co-Producer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "6479",
                  "name": "Sharon Bialy",
                  "imageUrl": "https://image.tmdb.org/t/p/original/uOex6LpaQYncD0sQfVYD1frI5uJ.jpg",
                  "share_url": "https://cut.watch/person/6479",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6444663ccee2f6049f36d7d3",
                      "role": "Casting",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223199",
                  "name": "Melissa Bernstein",
                  "imageUrl": "https://image.tmdb.org/t/p/original/rSztwqMUIko8RkmwjxBse1XDW3g.jpg",
                  "share_url": "https://cut.watch/person/1223199",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64189dbaa14bef00fd7d4bca",
                      "role": "Co-Producer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "5162",
                  "name": "Mark Johnson",
                  "imageUrl": "https://image.tmdb.org/t/p/original/gLuXkOQjqB81aHMGJ2OtYzEpHQu.jpg",
                  "share_url": "https://cut.watch/person/5162",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542287760ee31328001b69",
                      "role": "Executive Producer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "959387",
                  "name": "Sherry Thomas",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/959387",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64446643cee2f604f336e877",
                      "role": "Casting",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1218856",
                  "name": "Patty Lin",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1218856",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6418a01d0d5d8500f2d7be70",
                      "role": "Producer",
                      "episodeCount": 6
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1808170",
                  "name": "Gina Scheerer",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1808170",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6418a04de7414600b96bf1bd",
                      "role": "Associate Producer",
                      "episodeCount": 2
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1069688",
                  "name": "Thomas Golubić",
                  "imageUrl": "https://image.tmdb.org/t/p/original/umzkpmX3p3GdrSutAHFX7Rij0Sm.jpg",
                  "share_url": "https://cut.watch/person/1069688",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64634e45e3fa2f00e404a628",
                      "role": "Music Supervisor",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1280070",
                  "name": "Dave Porter",
                  "imageUrl": "https://image.tmdb.org/t/p/original/flRW9QknVtU8HG7lLjMvflbhl2a.jpg",
                  "share_url": "https://cut.watch/person/1280070",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52b7008819c29559eb03dd72",
                      "role": "Original Music Composer",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1537682",
                  "name": "Kurt Nicholas Forshager",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1537682",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "644986702fdec604e4a1236a",
                      "role": "Supervising Sound Editor",
                      "episodeCount": 7
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "66633",
                  "name": "Vince Gilligan",
                  "imageUrl": "https://image.tmdb.org/t/p/original/z3E0DhBg1V1PZVEtS9vfFPzOWYB.jpg",
                  "share_url": "https://cut.watch/person/66633",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542275760ee313280006ce",
                      "role": "Writer",
                      "episodeCount": 4
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1223193",
                  "name": "George Mastras",
                  "imageUrl": "https://image.tmdb.org/t/p/original/2K0NELbA0Ow45ECudbO2eFc1Fe4.jpg",
                  "share_url": "https://cut.watch/person/1223193",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "52542279760ee31328000b45",
                      "role": "Writer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "1218856",
                  "name": "Patty Lin",
                  "imageUrl": "https://image.tmdb.org/t/p/originalnull",
                  "share_url": "https://cut.watch/person/1218856",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "64189fca5690b5007a5592e1",
                      "role": "Writer",
                      "episodeCount": 1
                    }
                  ]
                },
                {
                  "__typename": "SeasonPerson",
                  "id": "24951",
                  "name": "Peter Gould",
                  "imageUrl": "https://image.tmdb.org/t/p/original/a2dJSpUiXQ2NAxqSzztr6WsnhOJ.jpg",
                  "share_url": "https://cut.watch/person/24951",
                  "roles": [
                    {
                      "__typename": "SeasonRole",
                      "id": "6443b361cee2f6044b36a4f2",
                      "role": "Writer",
                      "episodeCount": 1
                    }
                  ]
                }
              ],
              "episodes": [
                {
                  "__typename": "Episode",
                  "id": "62085",
                  "name": "Pilot",
                  "overview": "When an unassuming high school chemistry teacher discovers he has a rare form of lung cancer, he decides to team up with a former student and create a top of the line crystal meth in a used RV, to provide for his family once he is gone.",
                  "episode_number": 1,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/u90Ryx8OztC5OeVTXHPcZ8fnKoA.jpg",
                  "runtime": 59
                },
                {
                  "__typename": "Episode",
                  "id": "62086",
                  "name": "Cat's in the Bag...",
                  "overview": "Walt and Jesse attempt to tie up loose ends. The desperate situation gets more complicated with the flip of a coin. Walt's wife, Skyler, becomes suspicious of Walt's strange behavior.",
                  "episode_number": 2,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/xwQRVskT9IK7ktbrrWc2xoT4nPv.jpg",
                  "runtime": 49
                },
                {
                  "__typename": "Episode",
                  "id": "62087",
                  "name": "...And the Bag's in the River",
                  "overview": "Walter fights with Jesse over his drug use, causing him to leave Walter alone with their captive, Krazy-8. Meanwhile, Hank has a scared straight moment with Walter Jr. after his aunt discovers he has been smoking pot. Also, Skylar is upset when Walter stays away from home.",
                  "episode_number": 3,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/dLgiPZCVamFcaa7Gaqudrldj15h.jpg",
                  "runtime": 49
                },
                {
                  "__typename": "Episode",
                  "id": "62088",
                  "name": "Cancer Man",
                  "overview": "Walter finally tells his family that he has been stricken with cancer. Meanwhile, the DEA believes Albuquerque has a new, big time player to worry about. Meanwhile, a worthy recipient is the target of a depressed Walter's anger, and Jesse makes a surprise visit to his parents home.",
                  "episode_number": 4,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/2UbRgW6apE4XPzhHPA726wUFyaR.jpg",
                  "runtime": 49
                },
                {
                  "__typename": "Episode",
                  "id": "62089",
                  "name": "Gray Matter",
                  "overview": "Walter and Skyler attend a former colleague's party. Jesse tries to free himself from the drugs, while Skyler organizes an intervention.",
                  "episode_number": 5,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/82G3wZgEvZLKcte6yoZJahUWBtx.jpg",
                  "runtime": 49
                },
                {
                  "__typename": "Episode",
                  "id": "62090",
                  "name": "Crazy Handful of Nothin'",
                  "overview": "The side effects of chemo begin to plague Walt. Meanwhile, the DEA rounds up suspected dealers.",
                  "episode_number": 6,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/rCCLuycNPL30W3BtuB8HafxEMYz.jpg",
                  "runtime": 49
                },
                {
                  "__typename": "Episode",
                  "id": "62091",
                  "name": "A No Rough Stuff Type Deal",
                  "overview": "Walter accepts his new identity as a drug dealer after a PTA meeting. Elsewhere, Jesse decides to put his aunt's house on the market and Skyler is the recipient of a baby shower.",
                  "episode_number": 7,
                  "air_date": null,
                  "still_url": "https://image.tmdb.org/t/p/original/1dgFAsajUpUT7DLXgAxHb9GyXHH.jpg",
                  "runtime": 48
                }
              ]
            }
        """
        return parse(json)
    }

    static var episode: CutGraphQL.EpisodeFragment {
        let json = """
        {
          "__typename": "Episode",
          "id": "3335303",
          "name": "To Me, My X-Men",
          "overview": "Cyclops races to find the source of new anti-mutant technology.",
          "season_number": 2,
          "episode_number": 1,
          "air_date": "2008-01-20T00:00:00.000Z",
          "still_url": "https://image.tmdb.org/t/p/original/zLXRYta8yBVXvl1Hr6jjgL6Ofxh.jpg",
          "runtime": 33
        }
        """
        return parse(json)
    }
}
