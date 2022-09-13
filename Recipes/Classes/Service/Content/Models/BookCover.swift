//
//  BookCover.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import Foundation

struct BookCover: Codable, Hashable {
    let id: Int
    let name: String
    let author: Author
    let imageUrl: URL
    let rankingId: Int
    let shareLink: URL
    let paid: Bool
}
