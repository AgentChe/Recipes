//
//  GetRankingBooksRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire
import RushSDK

struct GetRankingBooksRequest: APIRequestBody {
    let userToken: String
    let rankingId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/ranking/books"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "ranking_id": rankingId
        ]
    }
}
