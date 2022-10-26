//
//  ShoppingTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.10.2022.
//

import CoreGraphics

enum ShoppingTableElement {
    case offset(CGFloat)
    case ingredient(Ingredient)
    case recipe(Shopping)
    case removeAllIngredients
}
