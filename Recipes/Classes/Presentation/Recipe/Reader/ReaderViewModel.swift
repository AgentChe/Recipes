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
    lazy var didSelectStep = PublishRelay<RecipeStep>()
    
    lazy var shareLink = makeShareLink()
    lazy var progress = makeProgress()
    lazy var isLastStep = makeIsLastStep()
    lazy var elements = makeElements()
    lazy var currentStep = makeCurrentStep()
    
    private let startStep: BehaviorRelay<RecipeStep>
    
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    
    init(recipe: Recipe, startStep: RecipeStep) {
        self.recipe = BehaviorRelay(value: recipe)
        self.startStep = BehaviorRelay(value: startStep)
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
                currentStep
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
                currentStep
            )
            .map { recipe, step -> Bool in
                guard let index = recipe.steps.firstIndex(of: step) else {
                    return true
                }
                
                return (recipe.steps.count - 1) == index
            }
            .distinctUntilChanged()
    }
    
    func makeCurrentStep() -> Driver<RecipeStep> {
        Driver
            .merge(
                startStep.asDriver(),
                didSelectStep.asDriver(onErrorDriveWith: .never())
            )
            .distinctUntilChanged()
    }
    
    func makeElements() -> Driver<[ReaderCollectionElement]> {
        recipe.asDriver()
            .map { [weak self] recipe -> [ReaderCollectionElement] in
                guard let self = self else {
                    return []
                }
                
                return recipe.steps.enumerated().map { index, step -> ReaderCollectionElement in
                    let isLast = (recipe.steps.count - 1) == index
                    return isLast ? self.createLastStepElement(recipe: recipe, step: step) : self.createStepElement(index: index, step: step)
                }
            }
    }
}

// MARK: Private(Additional)
private extension ReaderViewModel {
    func createLastStepElement(recipe: Recipe, step: RecipeStep) -> ReaderCollectionElement {
        var elements = [ReaderTableElement]()
        
        elements.append(contentsOf: [
            .lastStepTitle(recipe.name),
            .offset(18.scale),
            .image(recipe.imageUrl),
            .offset(30.scale),
            .lastStepText
        ])
        
        return ReaderCollectionElement(step: step, elements: elements)
    }
    
    func createStepElement(index: Int, step: RecipeStep) -> ReaderCollectionElement {
        let number = index + 1
        
        var elements = [ReaderTableElement]()
        
        elements.append(contentsOf: [
            .title(String(format: "Reader.StepNumber".localized, number)),
            .offset(16.scale),
            .text(step.text)
        ])

        if let imageUrl = step.imageUrl {
            elements.append(contentsOf: [
                .offset(16.scale),
                .image(imageUrl)
            ])
        }

        elements.append(.offset(24.scale))
        
        return ReaderCollectionElement(step: step, elements: elements)
    }
}
