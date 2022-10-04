//
//  GetCategoryRecipesRequest.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire

struct GetCategoryRecipesRequest: APIRequestBody {
    let userToken: String
    let categoryId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/categories/units"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "category_id": categoryId
        ]
    }
}
