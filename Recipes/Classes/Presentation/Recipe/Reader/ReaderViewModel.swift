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
    lazy var elements = makeElements()
    
    private lazy var currentStepElements = makeCurrentStepElements()
    private lazy var lastStepElements = makeLastStepElements()
    
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
    
    func makeElements() -> Driver<[ReaderTableElement]> {
        isLastStep
            .flatMapLatest { [weak self] isLastStep -> Driver<[ReaderTableElement]> in
                guard let self = self else {
                    return .never()
                }
                
                return isLastStep ? self.lastStepElements : self.currentStepElements
            }
    }
    
    func makeCurrentStepElements() -> Driver<[ReaderTableElement]> {
        Driver
            .combineLatest(
                recipe.asDriver(),
                currentStep.asDriver()
            )
            .map { recipe, step -> [ReaderTableElement] in
                guard let index = recipe.steps.firstIndex(of: step) else {
                    return []
                }
                
                let number = index + 1
                
                var result = [ReaderTableElement]()
                
                result.append(contentsOf: [
                    .title(String(format: "Reader.StepNumber".localized, number)),
                    .offset(16.scale),
                    .text(step.text)
                ])
                
                if let imageUrl = step.imageUrl {
                    result.append(contentsOf: [
                        .offset(16.scale),
                        .image(imageUrl)
                    ])
                }
                
                result.append(.offset(24.scale))
                
                return result
            }
    }
    
    func makeLastStepElements() -> Driver<[ReaderTableElement]> {
        recipe
            .asDriver()
            .map { recipe -> [ReaderTableElement] in
                var result = [ReaderTableElement]()
                
                result.append(contentsOf: [
                    .lastStepTitle(recipe.name),
                    .offset(18.scale),
                    .image(recipe.imageUrl),
                    .offset(30.scale),
                    .lastStepText
                ])
                
                return result
            }
    }
}
