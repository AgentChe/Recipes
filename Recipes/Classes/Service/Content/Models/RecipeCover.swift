//
//  RecipeCover.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import Foundation

struct RecipeCover: Codable, Hashable {
    let id: Int
    let name: String
    let time: Int
    let author: Author
    let imageUrl: URL
    let rankingId: Int
    let shareLink: URL
    let paid: Bool
}
