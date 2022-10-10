//
//  Recipe.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import Foundation

struct Recipe: Codable, Hashable {
    let id: Int
    let name: String
    let imageUrl: URL
    let rankingId: Int
    let categoriesIds: [Int]
    let timePreparing: Int?
    let timeCooking: Int?
    let totalTime: Int?
    let shareLink: URL
    let isSaved: Bool
    let steps: [RecipeStep]
    let ingredients: [Ingredient]
    let carbs: RecipeCPF
    let protein: RecipeCPF
    let fats: RecipeCPF
}
