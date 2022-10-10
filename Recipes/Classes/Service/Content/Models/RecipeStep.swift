//
//  RecipeStep.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import Foundation

struct RecipeStep: Codable, Hashable {
    let shortDescription: String
    let text: String
    let imageUrl: URL?
}
