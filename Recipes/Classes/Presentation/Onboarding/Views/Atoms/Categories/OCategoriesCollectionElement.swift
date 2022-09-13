//
//  OCategoriesCollectionElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

final class OCategoriesCollectionElement {
    let id: Int
    let title: String
    var selected: Bool
    
    init(title: String, id: Int) {
        self.title = title
        self.id = id
        self.selected = false
    }
}
