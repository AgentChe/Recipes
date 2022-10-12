//
//  ReaderViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import RxSwift
import RxCocoa

final class ReaderViewModel {
    let recipe: BehaviorRelay<Recipe>
    let currentStep: BehaviorRelay<RecipeStep>
    
    lazy var shareLink = makeShareLink()
    lazy var progress = makeProgress()
    lazy var isLastStep = makeIsLastStep()
    
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    
    init(recipe: Recipe, startStep: RecipeStep) {
        self.recipe = BehaviorRelay(value: recipe)
        self.currentStep = BehaviorRelay(value: startStep)
    }
}

// MARK: Private
private extension ReaderViewModel {
    func makeShareLink() -> Driver<URL> {
        recipe
            .map { $0.shareLink }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeProgress() -> Driver<Float> {
        Driver
            .combineLatest(
                recipe.asDriver(),
                currentStep.asDriver()
            )
            .flatMapLatest { [weak self] recipe, step -> Driver<RecipeReadingProgress> in
                guard let self = self else {
                    return .never()
                }
                
                guard let index = recipe.steps.firstIndex(of: step) else {
                    return .never()
                }
                
                let readingRecipe = RecipeReadingProgress(recipe: recipe, currentStepIndex: index)
                
                return self.contentManager
                    .set(recipeReadingProgress: readingRecipe)
                    .map { readingRecipe }
                    .asDriver(onErrorDriveWith: .never())
            }
            .map { readingRecipe -> Float in
                readingRecipe.progress
            }
    }
    
    func makeIsLastStep() -> Driver<Bool> {
        Driver
            .combineLatest(
                recipe.asDriver(),
                currentStep.asDriver()
            )
            .map { recipe, step -> Bool in
                guard let index = recipe.steps.firstIndex(of: step) else {
                    return true
                }
                
                return (recipe.steps.count - 1) == index
            }
    }
}
