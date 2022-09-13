//
//  GetDietsResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.09.2022.
//

final class GetDietsResponse {
    static func map(from response: Any) -> [Diet] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { dietJSON -> Diet? in
            guard
                let id = dietJSON["id"] as? Int,
                let name = dietJSON["name"] as? String
            else {
                return nil
            }
            
            return Diet(id: id,
                        name: name)
        }
    }
}
