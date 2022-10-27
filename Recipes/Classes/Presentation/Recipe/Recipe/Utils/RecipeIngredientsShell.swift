//
//  RecipeIngredientsShell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.10.2022.
//

final class RecipeIngredientsShell {
    let elements: [RecipeTableIngredientElement]
    let shoppingMarkedIngredients: [Ingredient]
    
    init(ingredients: [Ingredient],
         markedIngredients: [Ingredient],
         shoppingMarkedIngredients: [Ingredient]) {
        elements = ingredients.map { ingredient -> RecipeTableIngredientElement in
            RecipeTableIngredientElement(ingredient: ingredient,
                                         marked: markedIngredients.contains(where: { $0.id == ingredient.id }))
        }
        self.shoppingMarkedIngredients = shoppingMarkedIngredients
    }
}

// MARK: Public
extension RecipeIngredientsShell {
    var allSelected: Bool {
        !elements.contains(where: { !$0.marked })
    }
}
