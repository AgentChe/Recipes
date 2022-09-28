//
//  FeedbackResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

final class FeedbackResponse {
    static func map(from response: Any) -> Bool {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let success = data["success"] as? Bool
        else {
            return false
        }
        
        return success
    }
}
