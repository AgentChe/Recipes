//
//  GetChallengeRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import Alamofire
import RushSDK

struct GetChallengeRequest: APIRequestBody {
    let userToken: String
    let challengeId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/challenge"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "challenge_id": challengeId
        ]
    }
}
