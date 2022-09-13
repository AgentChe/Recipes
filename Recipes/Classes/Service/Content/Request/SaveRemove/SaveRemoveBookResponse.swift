//
//  SaveRemoveBookResponse.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

final class SaveRemoveBookResponse {
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
