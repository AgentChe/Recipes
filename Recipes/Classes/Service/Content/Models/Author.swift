//
//  Author.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

struct Author: Codable, Hashable {
    let name: String
    let photoUrl: URL
}
