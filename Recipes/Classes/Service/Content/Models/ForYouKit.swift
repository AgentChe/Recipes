//
//  ForYouKit.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

struct ForYouKit: Codable, Hashable {
    let freeRecipe: RecipeCover
    let todaysHotSummaries: [RecipeCover]
    let youMayLike: [RecipeCover]
    let breakfast: [RecipeCover]
    let lunch: [RecipeCover]
    let dinner: [RecipeCover]
    let snack: [RecipeCover]
    let quicklyPrepared: [RecipeCover]
    let rankings: [RankingRecipesGroup]
}
