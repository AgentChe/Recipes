//
//  Category.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import Foundation

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let imageUrl: URL
}
