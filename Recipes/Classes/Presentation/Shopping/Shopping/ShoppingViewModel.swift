//
//  ShoppingViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import RxSwift
import RxCocoa

final class ShoppingViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var filter = BehaviorRelay<ShoppingFilterView.Filter>(value: .allIngredients)
    lazy var didTapRemoveShopping = PublishRelay<Shopping>()
    lazy var didTapRemoveAllShoppings = PublishRelay<Void>()
    lazy var didTapRemoveIngredient = PublishRelay<(Ingredient, Shopping)>()
    
    lazy var elements = makeElements()
    lazy var emptyState = makeEmptyState()
    lazy var activity = RxActivityIndicator()
    
    private lazy var ingredientsElements = makeIngredientElements()
    private lazy var recipeElements = makeRecipeElements()
    private lazy var shoppings = makeShoppings()
    private lazy var removeShopping = makeRemoveShopping()
    private lazy var removeAllShoppings = makeRemoveAllShoppings()
    private lazy var removeIngredient = makeRemoveIngredient()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ShoppingViewModel {
    func makeEmptyState() -> Driver<ShoppingEmptyView.State?> {
        elements
            .withLatestFrom(filter.asDriver(onErrorDriveWith: .never())) { ($0, $1) }
            .map { elements, filter -> ShoppingEmptyView.State? in
                guard elements.isEmpty else {
                    return nil
                }
                
                switch filter {
                case .allIngredients:
                    return .allIngredients
                case .byRecipe:
                    return .byRecipe
                }
            }
            .startWith(nil)
    }
    
    func makeElements() -> Driver<[ShoppingTableElement]> {
        filter
            .asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] filter -> Driver<[ShoppingTableElement]> in
                guard let self = self else {
                    return .never()
                }
                
                switch filter {
                case .allIngredients:
                    return self.ingredientsElements
                case .byRecipe:
                    return self.recipeElements
                }
            }
    }
    
    func makeIngredientElements() -> Driver<[ShoppingTableElement]> {
        shoppings
            .map { shoppings -> [ShoppingTableElement] in
                var result = [ShoppingTableElement]()
                
                shoppings.forEach { shopping in
                    shopping.ingredients.forEach { ingredient in
                        let element = ShoppingTableIngredientElement(ingredient: ingredient,
                                                                     shopping: shopping)
                        result.append(contentsOf: [
                            .ingredient(element),
                            .offset(20.scale)
                        ])
                    }
                }
                
                if !result.isEmpty {
                    result.append(.removeAllIngredients)
                }
                
                return result
            }
    }
    
    func makeRecipeElements() -> Driver<[ShoppingTableElement]> {
        shoppings
            .map { shoppings -> [ShoppingTableElement] in
                var result = [ShoppingTableElement]()
                
                shoppings.enumerated().forEach { index, shopping in
                    result.append(.recipe(shopping))
                    
                    if (shoppings.count - 1) != index {
                        result.append(.offset(16.scale))
                    }
                }
                
                return result
            }
    }
    
    func makeShoppings() -> Driver<[Shopping]> {
        let nonActiveTriggers = Observable
            .merge(
                removeShopping.flatMap { Observable<Void>.never() },
                removeAllShoppings.flatMap { Observable<Void>.never() },
                removeIngredient.flatMapLatest { Observable<Void>.never() }
            )
        
        let activeTriggers = Observable
            .merge(
                ContentMediator.shared.shoppingUpdated
                    .asObservable()
                    .mapToVoid(),
                ContentMediator.shared.recipeDidRemovedShopping
                    .asObservable()
                    .mapToVoid(),
                ContentMediator.shared.recipeDidRemovedAllShoppings
                    .asObservable()
            )
        
        let triggers = Observable
            .merge(nonActiveTriggers, activeTriggers)
            .startWith(Void())
        
        return triggers
            .flatMapLatest { [weak self] void -> Single<[Shopping]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainShoppings()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRemoveShopping() -> Observable<Void> {
        didTapRemoveShopping
            .flatMapLatest { [weak self] shopping -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .removeShopping(recipeId: shopping.recipe.id)
            }
    }
    
    func makeRemoveAllShoppings() -> Observable<Void> {
        didTapRemoveAllShoppings
            .flatMapLatest { [weak self] void -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .removeAllShoppings()
            }
    }
    
    func makeRemoveIngredient() -> Observable<Void> {
        didTapRemoveIngredient
            .flatMapLatest { [weak self] ingredient, shopping -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                var ingredients = shopping.ingredients
                if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                    ingredients.remove(at: index)
                }
                
                let updated = Shopping(recipe: shopping.recipe, ingredients: ingredients)
                
                return self.contentManager
                    .set(shopping: updated)
            }
    }
}
