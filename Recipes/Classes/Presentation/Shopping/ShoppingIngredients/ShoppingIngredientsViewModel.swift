//
//  ShoppingIngredientsViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.10.2022.
//

import RxSwift
import RxCocoa

final class ShoppingIngredientsViewModel {
    lazy var didTapRemoveAllShoppings = PublishRelay<Void>()
    lazy var didTapRemoveIngredient = PublishRelay<Ingredient>()
    lazy var didTapMarkIngredient = PublishRelay<Ingredient>()
    
    lazy var elements = makeElements()
    
    private lazy var currentShopping = makeCurrentShopping()
    private lazy var actions = makeActions()
    private let initialShopping: BehaviorRelay<Shopping>
    
    private lazy var contentManager = ContentManager()
    
    init(shopping: Shopping) {
        self.initialShopping = BehaviorRelay(value: shopping)
    }
}

// MARK: Private
private extension ShoppingIngredientsViewModel {
    enum Action {
        case removeAll
        case remove(Ingredient)
        case mark(Ingredient)
    }
    
    func makeElements() -> Driver<[ShoppingIngredientsTableElement]> {
        currentShopping
            .map { shopping -> [ShoppingIngredientsTableElement] in
                var result = [ShoppingIngredientsTableElement]()
                
                shopping.ingredients.forEach { ingredient in
                    let marked = shopping.markedIngredients.contains(where: { $0.id == ingredient.id })
                    let element = ShoppingIngredientsTableIngredientElement(ingredient: ingredient,
                                                                            marked: marked)
                    result.append(.ingredient(element))
                }
                
                if !result.isEmpty {
                    result.append(contentsOf: [
                        .offset(20.scale),
                        .removeAllIngredients
                    ])
                }
                
                return result
            }
    }
    
    func makeCurrentShopping() -> Driver<Shopping> {
        initialShopping
            .asDriver()
            .flatMapLatest { [weak self] shopping -> Driver<Shopping> in
                guard let self = self else {
                    return .never()
                }
                
                return self.actions
                    .scan(shopping) { currentShopping, action -> Shopping in
                        switch action {
                        case .removeAll:
                            return self.prepareShoppingForRemoveAll(currentShopping)
                        case .remove(let ingredient):
                            return self.prepareShoppingForRemove(currentShopping, ingredient: ingredient)
                        case .mark(let ingredient):
                            return self.prepareShoppingForMark(currentShopping, ingredient: ingredient)
                        }
                    }
                    .startWith(shopping)
            }
            .flatMapLatest { [weak self] shopping -> Driver<Shopping> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .set(shopping: shopping)
                    .map { shopping }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeActions() -> Driver<Action> {
        Observable
            .merge(
                didTapRemoveAllShoppings.map { Action.removeAll },
                didTapRemoveIngredient.map { Action.remove($0) },
                didTapMarkIngredient.map { Action.mark($0) }
            )
            .asDriver(onErrorDriveWith: .never())
    }
    
    func prepareShoppingForRemoveAll(_ shopping: Shopping) -> Shopping {
        Shopping(recipe: shopping.recipe,
                 ingredients: [],
                 markedIngredients: [])
    }
    
    func prepareShoppingForRemove(_ shopping: Shopping, ingredient: Ingredient) -> Shopping {
        var ingredients = shopping.ingredients
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients.remove(at: index)
        }
        
        var markedIngredients = shopping.markedIngredients
        if let index = markedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
            markedIngredients.remove(at: index)
        }
        
        return Shopping(recipe: shopping.recipe,
                        ingredients: ingredients,
                        markedIngredients: markedIngredients)
    }
    
    func prepareShoppingForMark(_ shopping: Shopping, ingredient: Ingredient) -> Shopping {
        var markedIngredients = shopping.markedIngredients
        
        if let index = markedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
            markedIngredients.remove(at: index)
        } else {
            markedIngredients.append(ingredient)
        }
        
        return Shopping(recipe: shopping.recipe,
                        ingredients: shopping.ingredients,
                        markedIngredients: markedIngredients)
    }
}
