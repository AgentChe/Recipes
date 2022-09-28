//
//  GetDietsRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.09.2022.
//

import Alamofire

struct GetDietsRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/diets"
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
