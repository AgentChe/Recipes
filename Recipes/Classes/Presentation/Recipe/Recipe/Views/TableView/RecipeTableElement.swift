//
//  RecipeTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import CoreGraphics

enum RecipeTableElement {
    case offset(CGFloat)
    case transparent
    case info(RecipeTableInfoElement)
    case time(RecipeTableTimeElement)
    case title(String)
    case ingredient(RecipeTableIngredientElement)
    case shopping
}

struct RecipeTableInfoElement {
    let name: String
    let categories: [String]
}

struct RecipeTableTimeElement {
    let timePreparing: Int?
    let timeCooking: Int?
}

final class RecipeTableIngredientElement {
    let ingredient: Ingredient
    var marked: Bool
    
    init(ingredient: Ingredient, marked: Bool = false) {
        self.ingredient = ingredient
        self.marked = marked
    }
}
