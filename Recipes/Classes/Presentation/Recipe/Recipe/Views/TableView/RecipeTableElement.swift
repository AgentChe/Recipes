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
    case shopping(RecipeIngredientsShell)
    case step(RecipeTableStepElement)
    case separator
    case seeAll
    case cpf(RecipeTableCPFElement)
    case recipes([RecipeCover])
    case categories([Category])
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

struct RecipeTableStepElement {
    let step: RecipeStep
    let number: String
}

struct RecipeTableCPFElement {
    let carbs: RecipeCPF
    let protein: RecipeCPF
    let fats: RecipeCPF
}
