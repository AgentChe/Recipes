//
//  ShoppingIngredientsTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.10.2022.
//

import CoreGraphics

enum ShoppingIngredientsTableElement {
    case offset(CGFloat)
    case ingredient(ShoppingIngredientsTableIngredientElement)
    case removeAllIngredients
}

struct ShoppingIngredientsTableIngredientElement {
    let ingredient: Ingredient
    let marked: Bool
}
