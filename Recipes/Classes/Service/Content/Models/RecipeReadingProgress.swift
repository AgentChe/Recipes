//
//  RecipeReadingProgress.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

struct RecipeReadingProgress: Codable, Hashable {
    let recipe: Recipe
    let currentStepIndex: Int
}

// MARK: Public
extension RecipeReadingProgress {
    var progress: Float {
        guard !recipe.steps.isEmpty else {
            return 0
        }
        
        let number = (currentStepIndex + 1)
        return Float(number) / Float(recipe.steps.count)
    }
}
