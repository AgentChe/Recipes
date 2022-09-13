//
//  SetRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 28.08.2022.
//

import Alamofire

struct SetRequest: APIRequestBody {
    let userToken: String
    let goal: Int
    let categories: [Int]
    let diet: Int
    let pace: Int
    let time: Int
    let pushToken: String?
    let notificationsOptions: [Int]?
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "goal": goal,
            "categories": categories,
            "diet_id": diet,
            "pace": pace,
            "time": time
        ] as [String : Any]
        
        if let pushToken = pushToken {
            params["notification_key"] = pushToken
        }
        
        if let notificationsOptions = notificationsOptions {
            params["notification_options"] = notificationsOptions
        }
        
        return params
    }
}
