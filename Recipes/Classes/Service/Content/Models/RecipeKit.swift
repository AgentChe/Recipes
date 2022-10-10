//
//  RecipeKit.swift
//  Recipes
//
//  Created by Андрей Чернышев on 10.10.2022.
//

struct RecipeKit: Codable, Hashable {
    let recipe: Recipe
    let similarRecipes: [RecipeCover]
}
