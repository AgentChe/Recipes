//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import RxSwift
import RxCocoa

final class RecipeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapMark = PublishRelay<Bool>()
    lazy var didTapSeeAll = PublishRelay<Void>()
    lazy var didTapStep = PublishRelay<RecipeStep>()
    lazy var didTapRead = PublishRelay<Void>()
    
    lazy var isSavedRecipe = makeIsSavedRecipe()
    lazy var reader = makeReader()
    lazy var imageUrl = makeImageUrl()
    lazy var shareLink = makeShareLink()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var isShowingAll = makeIsShowingAll()
    private lazy var categories = makeCategories()
    private lazy var recipeKit = makeRecipeKit()
    private lazy var readingRecipes = makeReadingRecipes()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let recipeId: BehaviorRelay<Int>
    
    init(recipeId: Int) {
        self.recipeId = BehaviorRelay(value: recipeId)
    }
}

// MARK: Private
private extension RecipeViewModel {
    func makeIsSavedRecipe() -> Driver<Bool> {
        let initial = recipeKit
            .map { $0.recipe.isSaved }
        
        let action = didTapMark
            .withLatestFrom(recipeKit) { ($0, $1.recipe) }
            .flatMapFirst { [weak self] isSaved, recipe -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                        ? self.contentManager.removeSaved(recipe: RecipeCover(recipe: recipe))
                        : self.contentManager.save(recipe: RecipeCover(recipe: recipe))

                    return request
                        .map { _ in !isSaved }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, action)
    }
    
    func makeReader() -> Driver<(Recipe, RecipeStep)> {
        let step = didTapStep
            .withLatestFrom(recipeKit) { ($1.recipe, $0) }
            .asDriver(onErrorDriveWith: .never())
        
        let read = didTapRead
            .withLatestFrom(recipeKit)
            .withLatestFrom(readingRecipes) { recipeKit, readingRecipes -> (Recipe, RecipeStep)? in
                let recipe = recipeKit.recipe
                let recipeStep: RecipeStep?
                
                if let lastReadingStep = readingRecipes.first(where: { $0.recipe.id == recipe.id }) {
                    recipeStep = recipe.steps[safe: lastReadingStep.currentStepIndex] ?? recipe.steps.last
                } else {
                    recipeStep = recipe.steps.first
                }
                
                guard let recipeStep = recipeStep else {
                    return nil
                }

                return (recipe, recipeStep)
            }
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(step, read)
    }
    
    func makeImageUrl() -> Driver<URL> {
        recipeKit
            .map { $0.recipe.imageUrl }
    }
    
    func makeShareLink() -> Driver<URL> {
        recipeKit
            .map { $0.recipe.shareLink }
    }
    
    func makeElements() -> Driver<[RecipeTableElement]> {
        Driver
            .combineLatest(categories, recipeKit, isShowingAll)
            .map { categories, recipeKit, isShowingAll -> [RecipeTableElement] in
                var result = [RecipeTableElement]()
                
                let recipe = recipeKit.recipe
                
                result.append(.transparent)
                
                let recipeCategories = categories
                    .filter { recipe.categoriesIds.contains($0.id) }
                    .map { $0.name }
                let infoElement = RecipeTableInfoElement(name: recipe.name,
                                                         categories: recipeCategories)
                result.append(.info(infoElement))
                
                let hasTime = (recipe.timePreparing != nil) || (recipe.timeCooking != nil)
                if hasTime {
                    let element = RecipeTableTimeElement(timePreparing: recipe.timePreparing,
                                                         timeCooking: recipe.timeCooking)
                    result.append(contentsOf: [
                        .offset(18.scale),
                        .time(element)
                    ])
                }
                
                if !recipe.ingredients.isEmpty {
                    result.append(contentsOf: [
                        .offset(34.scale),
                        .title("Recipe.Ingredients".localized),
                        .offset(24.scale)
                    ])
                    
                    recipe.ingredients.enumerated().forEach { index, ingredient in
                        let element = RecipeTableIngredientElement(ingredient: ingredient)
                        result.append(.ingredient(element))
                        
                        if (recipe.ingredients.count - 1) != index {
                            result.append(.offset(20.scale))
                        }
                    }
                    
                    result.append(contentsOf: [
                        .offset(24.scale),
                        .shopping
                    ])
                }
                
                if !recipe.steps.isEmpty {
                    result.append(contentsOf: [
                        .offset(30.scale),
                        .title("Recipe.Steps".localized),
                        .offset(16.scale)
                    ])
                    
                    let steps = isShowingAll ? recipe.steps : Array(recipe.steps.prefix(5))
                    steps.enumerated().forEach { index, step in
                        let element = RecipeTableStepElement(step: step, number: String(index + 1))
                        result.append(.step(element))

                        if (steps.count - 1) != index {
                            result.append(contentsOf: [
                                .offset(16.scale),
                                .separator,
                                .offset(16.scale)
                            ])
                        }
                    }
                }
                
                let needShowSeeAll = recipe.steps.count > 5 && !isShowingAll
                if needShowSeeAll {
                    result.append(contentsOf: [
                        .offset(24.scale),
                        .seeAll
                    ])
                }
                
                return result
            }
    }
    
    func makeIsShowingAll() -> Driver<Bool> {
        didTapSeeAll
            .map { true }
            .startWith(false)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRecipeKit() -> Driver<RecipeKit> {
        recipeId
            .flatMapLatest { [weak self] recipeId -> Observable<RecipeKit> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<RecipeKit> {
                    self.contentManager
                        .obtainRecipeKit(recipeId: recipeId)
                        .flatMap { kit -> Single<RecipeKit> in
                            if let kit = kit {
                                return .just(kit)
                            }
                            
                            return .error(ContentError(.notContent))
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeReadingRecipes() -> Driver<[RecipeReadingProgress]> {
        let initial = contentManager
            .obtainReadingRecipes()
            .asDriver(onErrorJustReturn: [])
        
        let updated = ContentMediator.shared.recipeReadingProgressUpdated
            .flatMapLatest { [weak self] _ -> Driver<[RecipeReadingProgress]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainReadingRecipes()
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Driver.merge(initial, updated)
    }
}

// MARK: Additional (RecipeCover)
private extension RecipeCover {
    init(recipe: Recipe) {
        id = recipe.id
        name = recipe.name
        time = recipe.totalTime ?? 0
        imageUrl = recipe.imageUrl
        rankingId = recipe.rankingId
        shareLink = recipe.shareLink
        paid = false
    }
}
