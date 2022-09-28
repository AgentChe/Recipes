//
//  ODietsTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 28.09.2022.
//

final class ODietsTableElement {
    let diet: Category
    var marked: Bool
    
    init(diet: Category, marked: Bool = false) {
        self.diet = diet
        self.marked = marked
    }
}
