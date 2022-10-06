//
//  RRecipesTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import CoreGraphics

enum RRecipesTableElement {
    case offset(CGFloat)
    case recipe(RRecipesTableRecipeElement)
    case separator
}

struct RRecipesTableRecipeElement {
    let number: String
    let recipe: RecipeCover
}
