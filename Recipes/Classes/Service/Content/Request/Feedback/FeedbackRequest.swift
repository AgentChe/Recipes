//
//  FeedbackRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import Alamofire

struct FeedbackRequest: APIRequestBody {
    let userToken: String
    let recipeId: Int
    let rating: Int
    let improves: [Int]
    let whatBetter: String?
    let whatLearn: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/feedback"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "unit_id": recipeId,
            "rating": rating,
            "improves": improves
        ]
        
        if let whatBetter = whatBetter {
            params["what_better"] = whatBetter
        }
        
        if let whatLearn = whatLearn {
            params["what_learn"] = whatLearn
        }
        
        return params
    }
}
