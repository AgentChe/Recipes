//
//  RankingRecipesGroup.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.07.2022.
//

struct RankingRecipesGroup: Codable, Hashable {
    let rankingId: Int
    let recipes: [RecipeCover]
}
