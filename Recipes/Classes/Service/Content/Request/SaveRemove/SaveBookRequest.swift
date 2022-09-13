//
//  SaveBookRequest.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Alamofire
import RushSDK

struct SaveBookRequest: APIRequestBody {
    let userToken: String
    let bookId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/book/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "book_id": bookId
        ]
    }
}
