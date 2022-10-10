//
//  GetRecipeKitRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 10.10.2022.
//

import Alamofire

struct GetRecipeKitRequest: APIRequestBody {
    let userToken: String
    let recipeId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/units/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "unit_id": recipeId,
            "mode": 2
        ]
    }
}
