//
//  ShoppingTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.10.2022.
//

import CoreGraphics

enum ShoppingTableElement {
    case offset(CGFloat)
    case ingredient(ShoppingTableIngredientElement)
    case recipe(Shopping)
    case removeAllIngredients
}

struct ShoppingTableIngredientElement {
    let ingredient: Ingredient
    let shopping: Shopping
}
