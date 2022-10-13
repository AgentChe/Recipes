//
//  FeedbackCollector.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

struct FeedbackCollector {
    let rating = FeedbackRatingElement(rating: 0)
    let improves = FeedbackImprovesElement(improves: [])
    let whatBetter = FeedbackWhatBetterElement()
}
