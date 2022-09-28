//
//  Challenge.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import Foundation

struct Challenge: Codable, Hashable {
    let id: Int
    let name: String
    let title: String
    let text: String
    let imageUrl: URL
    let recipes: [BookCover]
}
