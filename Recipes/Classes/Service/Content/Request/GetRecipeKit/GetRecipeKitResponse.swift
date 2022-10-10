//
//  GetRecipeKitResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 10.10.2022.
//

import Foundation

final class GetRecipeKitResponse {
    static func map(from response: Any) -> RecipeKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let rankingId = data["ranking_id"] as? Int,
            let categoriesIds = data["categories_ids"] as? [Int],
            let timePreparing = data["time_preparing"] as? Int,
            let timeCooking = data["time_cooking"] as? Int,
            let timeTotal = data["time_min"] as? Int,
            let linkPath = data["link"] as? String,
            let linkUrl = URL(string: linkPath),
            let saved = data["saved"] as? Bool,
            let carbsJSON = data["carbs"] as? [String: Any],
            let carbs = map(cpfJSON: carbsJSON),
            let proteinJSON = data["protein"] as? [String: Any],
            let protein = map(cpfJSON: proteinJSON),
            let fatsJSON = data["fats"] as? [String: Any],
            let fats = map(cpfJSON: fatsJSON)
        else {
            return nil
        }
        
        let stepsArray = data["steps"] as? [[String: Any]] ?? []
        let steps = stepsArray.compactMap { stepJSON -> RecipeStep? in
            guard
                let shortDescription = stepJSON["short_description"] as? String,
                let text = stepJSON["text"] as? String,
                let imagePath = stepJSON["image"] as? String,
                let imageUrl = URL(string: imagePath)
            else {
                return nil
            }
            
            return RecipeStep(shortDescription: shortDescription,
                              text: text,
                              imageUrl: imageUrl)
        }
        
        let ingredientsArray = data["ingredients"] as? [[String: Any]] ?? []
        let ingredients = ingredientsArray.compactMap { ingredientJSON -> Ingredient? in
            guard
                let id = ingredientJSON["id"] as? Int,
                let name = ingredientJSON["name"] as? String,
                let value = ingredientJSON["value"] as? String
            else {
                return nil
            }
            
            return Ingredient(id: id,
                              name: name,
                              value: value)
        }
        
        let recipe = Recipe(id: id,
                            name: name,
                            imageUrl: imageUrl,
                            rankingId: rankingId,
                            categoriesIds: categoriesIds,
                            timePreparing: timePreparing,
                            timeCooking: timeCooking,
                            totalTime: timeTotal,
                            shareLink: linkUrl,
                            isSaved: saved,
                            steps: steps,
                            ingredients: ingredients,
                            carbs: carbs,
                            protein: protein,
                            fats: fats)
        
        let similarRecipesArray = data["similar_units"] as? [[String: Any]] ?? []
        let similarRecipes = similarRecipesArray.compactMap { map(coverJSON: $0) }
        
        return RecipeKit(recipe: recipe,
                         similarRecipes: similarRecipes)
    }
}

// MARK: Private
private extension GetRecipeKitResponse {
    static func map(cpfJSON: [String: Any]) -> RecipeCPF? {
        guard
            let gram = cpfJSON["g"] as? Int,
            let percent = cpfJSON["percent"] as? Int
        else {
            return nil
        }
        
        return RecipeCPF(gram: gram, percent: percent)
    }
    
    static func map(coverJSON: [String: Any]) -> RecipeCover? {
        guard
            let id = coverJSON["id"] as? Int,
            let name = coverJSON["name"] as? String,
            let time = coverJSON["time_min"] as? Int,
            let imagePath = coverJSON["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let rankingId = coverJSON["ranking_id"] as? Int,
            let shareLinkPath = coverJSON["link"] as? String,
            let shareLink = URL(string: shareLinkPath),
            let paid = coverJSON["paid"] as? Bool
        else {
            return nil
        }
        
        return RecipeCover(id: id,
                         name: name,
                         time: time,
                         imageUrl: imageUrl,
                         rankingId: rankingId,
                         shareLink: shareLink,
                         paid: paid)
    }
}
