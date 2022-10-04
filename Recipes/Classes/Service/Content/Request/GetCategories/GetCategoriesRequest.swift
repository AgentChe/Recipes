//
//  GetCategoriesRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire

struct GetCategoriesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/categories"
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
