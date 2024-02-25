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
}
