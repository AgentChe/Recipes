//
//  RequestReview.swift
//  Recipes
//
//  Created by Андрей Чернышев on 08.12.2022.
//

import StoreKit

final class RequestReview {
    static func request() {
        guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else {
            return
        }

        AmplitudeManager.shared
            .logEvent(name: "Rating Request")

        DispatchQueue.main.async {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
