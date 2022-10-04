//
//  ForYouTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import CoreGraphics

enum ForYouTableElement {
    case offset(CGFloat)
    case freeRecipe(RecipeCover)
    case title(String)
    case recipes([RecipeCover])
    case challenges([ChallengeCover])
    case rankingTitle(Ranking)
    case rankingRecipe(RecipeCover)
    case separator
    case categories([Category])
}
