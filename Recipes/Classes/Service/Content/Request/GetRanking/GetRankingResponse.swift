//
//  GetRankingResponse.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

final class GetRankingResponse {
    static func map(from response: Any) -> [Ranking] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { rankingJSON -> Ranking? in
            guard
                let id = rankingJSON["id"] as? Int,
                let name = rankingJSON["name"] as? String
            else {
                return nil
            }
            
            return Ranking(id: id,
                            name: name)
        }
    }
}
