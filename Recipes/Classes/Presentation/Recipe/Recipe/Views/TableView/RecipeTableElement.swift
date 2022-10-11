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
}

struct RecipeTableInfoElement {
    let name: String
    let categories: [String]
}

struct RecipeTableTimeElement {
    let timePreparing: Int?
    let timeCooking: Int?
}
