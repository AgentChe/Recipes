//
//  ForYouKit.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

struct ForYouKit: Codable, Hashable {
    let freeRecipe: RecipeCover
    let todaysHotSummaries: [RecipeCover]
    let challenges: [ChallengeCover]
    let youMayLike: [RecipeCover]
    let rankings: [RankingRecipesGroup]
}
