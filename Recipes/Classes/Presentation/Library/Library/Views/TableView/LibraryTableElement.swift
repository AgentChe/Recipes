//
//  LibraryTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import CoreGraphics

enum LibraryTableElement {
    case offset(CGFloat)
    case recipe(LibraryTableRecipeElement)
    case separator
}

struct LibraryTableRecipeElement {
    let recipe: RecipeCover
    let progress: Float?
}
