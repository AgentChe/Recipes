//
//  ChallengeTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import CoreGraphics

enum ChallengeTableElement {
    case offset(CGFloat)
    case header(ChallengeHeaderElement)
    case buttons(ChallengeButtonsElement)
    case recipes([ChallengeRecipeElement])
    case badges(ChallengeBadgesElement)
}

struct ChallengeHeaderElement {
    let name: String
    let title: String
    let text: String
}

struct ChallengeButtonsElement {
    let currentDayRecipeId: Int
}

struct ChallengeRecipeElement {
    let dayNumber: Int
    let recipe: RecipeCover
    let completed: Bool
    let current: Bool
}

struct ChallengeBadgesElement {
    let goodStartProgress: Int
    let completeDay3Progress: Int
    let completeChallengeProgress: Int
}
