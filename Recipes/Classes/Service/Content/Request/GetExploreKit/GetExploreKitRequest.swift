//
//  GetExploreKitRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire
import RushSDK

struct GetExploreKitRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/explore"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
