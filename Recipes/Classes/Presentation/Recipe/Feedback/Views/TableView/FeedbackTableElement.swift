//
//  FeedbackTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import CoreGraphics

enum FeedbackTableElement {
    case offset(CGFloat)
    case recipe(String)
    case rating(FeedbackRatingElement)
    case improves(FeedbackImprovesElement)
    case whatBetter(FeedbackWhatBetterElement)
}

final class FeedbackRatingElement {
    var rating: Int
    
    init(rating: Int) {
        self.rating = rating
    }
}

final class FeedbackImprovesElement {
    var improves: [Int]
    
    init(improves: [Int]) {
        self.improves = improves
    }
}

final class FeedbackWhatBetterElement {
    var text: String?
}
