//
//  RateContentSheet.swift
//  Cut
//
//  Created by Kyle Satti on 6/23/24.
//

import SwiftUI

struct RateContentSheet: View {
    let contentId: String
    @State var rating = 0
    @State var error: Error?
    @Environment(\.dismiss) var dismiss


    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach((1..<6), id: \.self) { i in
                        Button(action: {
                            setRating(i)
                        }, label: {
                            if i <= rating {
                                Image(rating <= 3 ? "silver_rating" : "gold_rating")
                            } else {
                                Image("rating_placeholder")
                            }
                        })
                    }
                }
                Text(ratingDescription())
            }
            .padding()
            .background(UIColor.gray95.color)
            .mask { RoundedRectangle(cornerRadius: 15) }
            PrimaryButton("Submit") {
                submit()
            }
        }
        .padding(.horizontal, 24)
        .presentationDetents([.height(280)])
    }

    private func ratingDescription() -> String {
        switch rating {
        case 1: return "Bad"
        case 2: return "Background worthy"
        case 3: return "Good"
        case 4: return "Great"
        case 5: return "Absolute Cinema"
        default: return ""
        }
    }

    private func setRating(_ rating: Int) {
        self.rating = rating
    }

    private func submit() {
        guard rating > 0 else {
            dismiss()
            return
        }

        AuthorizedApolloClient.shared.client
            .perform(
                mutation: CutGraphQL.RateMutation(
                    contentId: contentId, rating: rating
                )
            ) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    let content = data.rate.content.fragments.contentFragment
                    WatchListCacheUpdate.updateCache(add: false, maybeIndex: nil, newContentId: content.id, content: content)
                    dismiss()
                case .failure(let error):
                    self.error = error
                }
            }
    }
}

#Preview {
    RateContentSheet(contentId: "")
}
