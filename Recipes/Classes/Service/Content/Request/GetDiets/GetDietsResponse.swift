//
//  GetDietsResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 04.10.2022.
//

import Foundation

final class GetDietsResponse {
    static func map(from response: Any) -> [Category] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { categoryJSON -> Category? in
            guard
                let id = categoryJSON["id"] as? Int,
                let name = categoryJSON["name"] as? String,
                let imagePath = categoryJSON["image"] as? String,
                let imageUrl = URL(string: imagePath)
            else {
                return nil
            }
            
            return Category(id: id,
                            name: name,
                            imageUrl: imageUrl)
        }
    }
}
