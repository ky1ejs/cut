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

    static var completeAccount: CutGraphQL.GetAccountQuery.Data.Account.AsCompleteAccount {
        let json = """
        {
            "__typename": "Query",
            "account": {
              "__typename": "CompleteAccount",
              "username": "kylejs",
              "name": "Kyle Satti",
              "bio": "Co-founder of Cut",
              "url": "https://kylejs.dev",
              "id": "72686e5d-025f-46ef-b78d-a1511fd01383",
              "followerCount": 0,
              "followingCount": 0,
              "watchList": [],
              "followers": [],
              "following": []
            }
          }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.GetAccountQuery.Data(data: jsonObject).account.asCompleteAccount!
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
          "imageUrl": null
        }
        """
        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
        return try! CutGraphQL.ProfileFragment(data: jsonObject)
    }
}
