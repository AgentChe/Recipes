//
//  StepsTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import CoreGraphics

enum StepsTableElement {
    case offset
    case step(StepTableElement)
}

struct StepTableElement {
    let number: String
    let step: RecipeStep
    let isSelected: Bool
    let separatorHidden: Bool
}
