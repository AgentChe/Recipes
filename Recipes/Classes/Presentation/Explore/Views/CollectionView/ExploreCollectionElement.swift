//
//  ExploreCollectionElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import CoreGraphics

enum ExploreCollectionElement {
    case verticalOffset(CGFloat)
    case title(String, large: Bool)
    case categories([Category])
    case recipe(RecipeCover)
    case separator
}
