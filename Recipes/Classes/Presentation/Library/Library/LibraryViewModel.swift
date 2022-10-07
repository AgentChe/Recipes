//
//  LibraryViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import RxSwift
import RxCocoa

final class LibraryViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var filter = PublishRelay<LibraryFilterView.Filter>()
    lazy var didTapRemove = PublishRelay<RecipeCover>()
    
    lazy var elements = makeElements()
    lazy var emptyState = makeEmptyState()
    lazy var activity = RxActivityIndicator()
    
    private lazy var recipesElements = makeRecipesElements()
    private lazy var savedRecipesElements = makeSavedRecipesElements()
    private lazy var historyRecipesElements = makeHistoryRecipesElements()
    private lazy var readingRecipes = makeReadingRecipes()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension LibraryViewModel {
    func makeEmptyState() -> Driver<LibraryEmptyView.State?> {
        elements
            .withLatestFrom(filter.asDriver(onErrorDriveWith: .never())) { ($0, $1) }
            .map { elements, filter -> LibraryEmptyView.State? in
                guard elements.isEmpty else {
                    return nil
                }
                
                switch filter {
                case .saved:
                    return .saved
                case .history:
                    return .history
                }
            }
            .startWith(nil)
    }
    
    func makeElements() -> Driver<[LibraryTableElement]> {
        recipesElements
            .map { recipesElements -> [LibraryTableElement] in
                var result = [LibraryTableElement]()
                
                recipesElements.enumerated().forEach { index, recipeElement in
                    result.append(.recipe(recipeElement))
                    
                    if (recipesElements.count - 1) != index {
                        result.append(contentsOf: [
                            .offset(16.scale),
                            .separator,
                            .offset(16.scale)
                        ])
                    }
                }
                
                return result
            }
    }
    
    func makeRecipesElements() -> Driver<[LibraryTableRecipeElement]> {
        filter.asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] filter -> Driver<[LibraryTableRecipeElement]> in
                guard let self = self else {
                    return .never()
                }
                
                switch filter {
                case .saved:
                    return self.savedRecipesElements
                case .history:
                    return self.historyRecipesElements
                }
            }
    }
    
    func makeSavedRecipesElements() -> Driver<[LibraryTableRecipeElement]> {
        let savedRecipes = downloadSavedRecipes()
            .flatMapLatest { [weak self] recipes -> Driver<[RecipeCover]> in
                guard let self = self else {
                    return .never()
                }
                
                let saved = ContentMediator.shared
                    .recipeDidSaved
                    .map { (1, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let removed = ContentMediator.shared
                    .recipeDidRemoveFromSaved
                    .map { (2, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let libraryDelete = self.didTapRemove
                    .flatMapLatest { recipe -> Single<(Int, RecipeCover)> in
                        self.contentManager
                            .removeSaved(recipe: recipe)
                            .map { success in (2, recipe) }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(saved, removed, libraryDelete)
                    .scan(recipes) { recipes, args -> [RecipeCover] in
                        let (action, recipe) = args
                        
                        var copy = recipes
                        
                        if action == 1 {
                            if let index = copy.firstIndex(where: { $0.id == recipe.id }) {
                                copy[index] = recipe
                            } else {
                                copy.append(recipe)
                            }
                        } else if action == 2 {
                            if let index = copy.firstIndex(where: { $0.id == recipe.id }) {
                                copy.remove(at: index)
                            }
                        }
                        
                        return copy
                    }
                    .startWith(recipes)
            }
        
        return Driver
            .combineLatest(savedRecipes, readingRecipes)
            .map { savedRecipes, readingRecipes -> [LibraryTableRecipeElement] in
                Self.combine(recipesCovers: savedRecipes, readingRecipes: readingRecipes)
            }
    }
    
    func makeHistoryRecipesElements() -> Driver<[LibraryTableRecipeElement]> {
        readingRecipes
            .map { readingRecipes -> [LibraryTableRecipeElement] in
                readingRecipes.map { readingRecipe -> LibraryTableRecipeElement in
                    LibraryTableRecipeElement(recipe: RecipeCover(recipe: readingRecipe.recipe),
                                            progress: readingRecipe.progress)
                }
            }
    }
    
    func makeReadingRecipes() -> Driver<[RecipeReadingProgress]> {
        contentManager
            .obtainReadingRecipes()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { [weak self] readingRecipes -> Driver<[RecipeReadingProgress]> in
                guard let self = self else {
                    return .never()
                }
                
                let updated = ContentMediator.shared
                    .recipeReadingProgressUpdated
                    .map { (1, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let libraryDelete = self.didTapRemove
                    .flatMapLatest { recipe -> Single<(Int, RecipeReadingProgress)> in
                        self.contentManager
                            .removeRecipeProgress(recipeId: recipe.id)
                            .map { (2, RecipeReadingProgress(recipe: Recipe(id: recipe.id), currentStepIndex: 0)) }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(updated, libraryDelete)
                    .scan(readingRecipes) { recipes, args -> [RecipeReadingProgress] in
                        let (action, readingRecipe) = args
                        
                        var copy = recipes
                        
                        if action == 1 {
                            if let index = copy.firstIndex(where: { $0.recipe.id == readingRecipe.recipe.id }) {
                                copy[index] = readingRecipe
                            } else {
                                copy.append(readingRecipe)
                            }
                        } else if action == 2 {
                            if let index = copy.firstIndex(where: { $0.recipe.id == readingRecipe.recipe.id }) {
                                copy.remove(at: index)
                            }
                        }
                        
                        return copy
                    }
                    .startWith(readingRecipes)
            }
    }
    
    func downloadSavedRecipes() -> Driver<[RecipeCover]> {
        func source() -> Single<[RecipeCover]> {
            contentManager
                .obtainSavedRecipesCover()
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
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Utils
private extension LibraryViewModel {
    static func combine(recipesCovers: [RecipeCover], readingRecipes: [RecipeReadingProgress]) -> [LibraryTableRecipeElement] {
        recipesCovers.map { recipe -> LibraryTableRecipeElement in
            let readingRecipe = readingRecipes.first(where: { $0.recipe.id == recipe.id })

            return LibraryTableRecipeElement(recipe: recipe,
                                             progress: readingRecipe?.progress)
        }
    }
}

// MARK: Additional (RecipeCover)
private extension RecipeCover {
    init(recipe: Recipe) {
        id = recipe.id
        name = recipe.name
        author = recipe.author
        imageUrl = recipe.imageUrl
        rankingId = recipe.rankingId
        shareLink = recipe.shareLink
        paid = false
        time = recipe.time
    }
}

// MARK: Additional (Recipe)
private extension Recipe {
    init(id: Int) {
        self.id = id
        name = ""
        imageUrl = URL(string: "www.google.com")!
        author = Author(name: "", photoUrl: URL(string: "www.google.com")!)
        rankingId = 0
        time = 0
        audioUrl = URL(string: "www.google.com")!
        shareLink = URL(string: "www.google.com")!
        isSaved = false
        introduction = nil
        steps = []
        whatAbout = ""
    }
}
