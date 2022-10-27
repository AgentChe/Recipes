//
//  Shopping.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.10.2022.
//

struct Shopping: Codable, Hashable {
    let recipe: RecipeCover
    let ingredients: [Ingredient]
    let markedIngredients: [Ingredient]
}
