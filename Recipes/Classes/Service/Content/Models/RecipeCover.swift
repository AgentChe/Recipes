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
    let timePreparing: Int?
    let timeCooking: Int?
    let imageUrl: URL
    let rankingId: Int
    let shareLink: URL
    let paid: Bool
}
