//
//  SaveRecipeRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire
import RushSDK

struct SaveRecipeRequest: APIRequestBody {
    let userToken: String
    let recipeId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/units/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "unit_id": recipeId
        ]
    }
}
