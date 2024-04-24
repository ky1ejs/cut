//
//  MovieJson.swift
//  Cut
//
//  Created by Kyle Satti on 2/24/24.
//

import Foundation

struct Mocks {
    static var movie: Movie {
        let json = """
            {
              "__typename": "Movie",
              "title": "The Godfather",
              "id": "TMDB:1072790",
              "poster_url": "https://image.tmdb.org/t/p/original/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
              "release_date": "Mon Mar 13 1972 19:00:00 GMT-0500 (Eastern Standard Time)",
              "mainGenre": null,
              "genres": [
                {
                  "__typename": "Genre",
                  "name": "War",
                  "id": 18
                }
              ],
              "isOnWatchList": true
            }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.MovieFragment(data: jsonObject)
    }

    static var favoriteMovie: CutGraphQL.FavoriteMovieFragment {
        let json = """
            {
              "__typename": "Movie",
              "id": "TMDB:1072790",
              "poster_url": "https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg",
              "allIds": [
                 "45996cad-3548-46f5-b2e6-0b309c7e34d0",
                 "3542226f-c12d-44de-b507-45f314eba69c",
                 "8253d3df-1838-4423-a701-30cdd6b1e7a3"
              ]
            }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.FavoriteMovieFragment(data: jsonObject)
    }

    static var completeAccount: CutGraphQL.CompleteAccountFragment {
        let json = """
        {
              "__typename": "CompleteAccount",
              "username": "kylejs",
              "name": "Kyle Satti",
              "bio": "Co-founder of Cut",
              "url": "https://kylejs.dev",
              "id": "72686e5d-025f-46ef-b78d-a1511fd01383",
              "followerCount": 0,
              "followingCount": 0,
              "link": "https://cut.watch/p/fab",
              "watchList": [
                  {
                    "__typename": "Movie",
                    "title": "12 Angry Men",
                    "id": "e2754aa7-7d73-474a-bf53-7fcffdc7ac57",
                    "poster_url": "https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg",
                    "release_date": "Tue Apr 09 1957 19:00:00 GMT-0500 (Eastern Daylight Time)",
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
                      }
                    ],
                    "isOnWatchList": false
                  }
              ],
              "favoriteMovies": [
                  {
                    "__typename": "Movie",
                    "title": "12 Angry Men",
                    "id": "e2754aa7-7d73-474a-bf53-7fcffdc7ac57",
                    "poster_url": "https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg",
                    "release_date": "Tue Apr 09 1957 19:00:00 GMT-0500 (Eastern Daylight Time)",
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
                      }
                    ],
                    "isOnWatchList": false
                  }
              ]
        }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.CompleteAccountFragment(data: jsonObject)
    }

    static var profile: CutGraphQL.ProfileFragment {
        let json = """
        {
          "__typename": "Profile",
          "id": "72e64fb2-5f32-4a4f-9144-cdb16b86629b",
          "username": "fab",
          "name": "Fabiano Souza",
          "url": "https://threads.com/fab",
          "bio": "Co-founder of Cut",
          "imageUrl": null,
          "isFollowing": false,
          "link": "https://cut.watch/p/fab"
        }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.ProfileFragment(data: jsonObject)
    }

    static var profileInterface: CutGraphQL.ProfileInterfaceFragment {
        profile.fragments.profileInterfaceFragment
    }
}
