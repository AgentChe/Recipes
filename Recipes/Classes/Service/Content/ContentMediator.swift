//
//  ContentMediator.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import RxCocoa

protocol ContentMediatorDelegate: AnyObject {
    func contentMediatorDidSaved(recipe: BookCover)
    func contentMediatorDidRemovedSaved(recipe: BookCover)
    func contentMediatorDidUpdated(recipeReadingProgress: BookReadingProgress)
    func contentMediatorDidRemovedProgress(recipeId: Int)
}

final class ContentMediator {
    static let shared = ContentMediator()
    
    private var delegates = [Weak<ContentMediatorDelegate>]()
    
    private lazy var recipeDidSavedTrigger = PublishRelay<BookCover>()
    private lazy var recipeDidRemoveFromSavedTrigger = PublishRelay<BookCover>()
    private lazy var recipeReadingProgressUpdatedTrigger = PublishRelay<BookReadingProgress>()
    private lazy var recipeDidRemovedProgressTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension ContentMediator {
    func notifyAboutSaved(recipe: BookCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidSaved(recipe: recipe)
            }
            
            self?.recipeDidSavedTrigger.accept(recipe)
        }
    }
    
    func notifyAboutRemoveSaved(recipe: BookCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedSaved(recipe: recipe)
            }
            
            self?.recipeDidRemoveFromSavedTrigger.accept(recipe)
        }
    }
    
    func notifyAboutUpdate(recipeReadingProgress: BookReadingProgress) {
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
}

// MARK: Public (Triggers)
extension ContentMediator {
    var recipeDidSaved: Signal<BookCover> {
        recipeDidSavedTrigger.asSignal()
    }
    
    var recipeDidRemoveFromSaved: Signal<BookCover> {
        recipeDidRemoveFromSavedTrigger.asSignal()
    }
    
    var recipeReadingProgressUpdated: Signal<BookReadingProgress> {
        recipeReadingProgressUpdatedTrigger.asSignal()
    }
    
    var recipeDidRemovedProgress: Signal<Int> {
        recipeDidRemovedProgressTrigger.asSignal()
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
