//
//  SearchBooksRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire
import RushSDK

struct SearchBooksRequest: APIRequestBody {
    let userToken: String
    let search: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/search"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "search": search
        ]
    }
}
