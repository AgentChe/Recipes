//
//  Ingredient.swift
//  Recipes
//
//  Created by Андрей Чернышев on 10.10.2022.
//

struct Ingredient: Codable, Hashable {
    let id: Int
    let name: String
    let value: String
}
