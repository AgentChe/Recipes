//
//  ContentMediator.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import RxCocoa

protocol ContentMediatorDelegate: AnyObject {
    func contentMediatorDidSaved(recipe: RecipeCover)
    func contentMediatorDidRemovedSaved(recipe: RecipeCover)
    func contentMediatorDidUpdated(recipeReadingProgress: RecipeReadingProgress)
    func contentMediatorDidRemovedProgress(recipeId: Int)
    func contentMediatorDidUpdated(shopping: Shopping)
    func contentMediatorDidRemovedShopping(recipeId: Int)
}

final class ContentMediator {
    static let shared = ContentMediator()
    
    private var delegates = [Weak<ContentMediatorDelegate>]()
    
    private lazy var recipeDidSavedTrigger = PublishRelay<RecipeCover>()
    private lazy var recipeDidRemoveFromSavedTrigger = PublishRelay<RecipeCover>()
    private lazy var recipeReadingProgressUpdatedTrigger = PublishRelay<RecipeReadingProgress>()
    private lazy var recipeDidRemovedProgressTrigger = PublishRelay<Int>()
    private lazy var shoppingUpdatedTrigger = PublishRelay<Shopping>()
    private lazy var recipeDidRemovedShoppingTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension ContentMediator {
    func notifyAboutSaved(recipe: RecipeCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidSaved(recipe: recipe)
            }
            
            self?.recipeDidSavedTrigger.accept(recipe)
        }
    }
    
    func notifyAboutRemoveSaved(recipe: RecipeCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedSaved(recipe: recipe)
            }
            
            self?.recipeDidRemoveFromSavedTrigger.accept(recipe)
        }
    }
    
    func notifyAboutUpdate(recipeReadingProgress: RecipeReadingProgress) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidUpdated(recipeReadingProgress: recipeReadingProgress)
            }
            
            self?.recipeReadingProgressUpdatedTrigger.accept(recipeReadingProgress)
        }
    }
    
    func notifyAboutUpdateRemovedProgress(recipeId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedProgress(recipeId: recipeId)
            }
            
            self?.recipeDidRemovedProgressTrigger.accept(recipeId)
        }
    }
    
    func notifyAboutUpdate(shopping: Shopping) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidUpdated(shopping: shopping)
            }
            
            self?.shoppingUpdatedTrigger.accept(shopping)
        }
    }
    
    func notifyAboutRemovedShopping(recipeId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedShopping(recipeId: recipeId)
            }
            
            self?.recipeDidRemovedShoppingTrigger.accept(recipeId)
        }
    }
}

// MARK: Public (Triggers)
extension ContentMediator {
    var recipeDidSaved: Signal<RecipeCover> {
        recipeDidSavedTrigger.asSignal()
    }
    
    var recipeDidRemoveFromSaved: Signal<RecipeCover> {
        recipeDidRemoveFromSavedTrigger.asSignal()
    }
    
    var recipeReadingProgressUpdated: Signal<RecipeReadingProgress> {
        recipeReadingProgressUpdatedTrigger.asSignal()
    }
    
    var recipeDidRemovedProgress: Signal<Int> {
        recipeDidRemovedProgressTrigger.asSignal()
    }
    
    var shoppingUpdated: Signal<Shopping> {
        shoppingUpdatedTrigger.asSignal()
    }
    
    var recipeDidRemovedShopping: Signal<Int> {
        recipeDidRemovedShoppingTrigger.asSignal()
    }
}

// MARK: Public (Observer)
extension ContentMediator {
    func add(delegate: ContentMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ContentMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: ContentMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
