//
//  RankingsCollectionElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

final class RankingsCollectionElement {
    let ranking: Ranking
    var isSelected: Bool
    
    init(ranking: Ranking,
         isSelected: Bool = false) {
        self.ranking = ranking
        self.isSelected = isSelected
    }
}
