//
//  ChallengeViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import RxSwift
import RxCocoa

final class ChallengeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var progress = makeProgress()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var challenge = makeChallenge()
    private lazy var readingRecipes = makeReadingRecipes()
    private let challengeId: BehaviorRelay<Int>
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(challengeId: Int) {
        self.challengeId = BehaviorRelay(value: challengeId)
    }
}

// MARK: Private
private extension ChallengeViewModel {
    func makeProgress() -> Driver<Int> {
        Driver
            .combineLatest(
                challenge.map { $0.recipes },
                readingRecipes
            ) { challengeRecipes, readingRecipes -> Int in
                let readRecipesAtChallenge = readingRecipes
                    .filter { readingRecipe -> Bool in
                        challengeRecipes.contains(where: { $0.id == readingRecipe.recipe.id })
                    }
                    .filter { $0.progress == 1 }
                
                let readRecipesCount = Float(readRecipesAtChallenge.count)
                let totalRecipesCount = Float(challengeRecipes.count)
                
                guard totalRecipesCount > 0 else {
                    return 0
                }
                
                let progress = readRecipesCount / totalRecipesCount * 100
                
                return Int(progress)
            }
    }
    
    func makeElements() -> Driver<[ChallengeTableElement]> {
        Driver
            .combineLatest(challenge, readingRecipes)
            .map { [weak self] challenge, readingRecipes -> [ChallengeTableElement] in
                guard let self = self else {
                    return []
                }
                
                let readingRecipesAtChallenge = readingRecipes.filter { readingRecipe -> Bool in
                    challenge.recipes.contains(where: { $0.id == readingRecipe.recipe.id })
                }
                
                var result = [ChallengeTableElement]()
                
                let header = ChallengeHeaderElement(name: challenge.name,
                                                    title: challenge.title,
                                                    text: challenge.text)
                result.append(.header(header))
                
                let isCompleteChallenge = self.isCompleteChallenge(readingRecipes: readingRecipesAtChallenge,
                                                                   challengeRecipesCount: challenge.recipes.count)
                let readingDayRecipeId = self.readingDayRecipeId(readingRecipes: readingRecipes,
                                                             challengeRecipes: challenge.recipes)
                if !isCompleteChallenge, let readingDayRecipeId = readingDayRecipeId {
                    let element = ChallengeButtonsElement(currentDayRecipeId: readingDayRecipeId)
                    
                    result.append(contentsOf: [
                        .offset(20.scale),
                        .buttons(element)
                    ])
                }
                
                let recipes = challenge.recipes.enumerated().map { index, recipe -> ChallengeRecipeElement in
                    let completed = readingRecipesAtChallenge.first(where: { $0.recipe.id == recipe.id })?.progress == 1
                    
                    return ChallengeRecipeElement(dayNumber: index + 1,
                                                  recipe: recipe,
                                                  completed: completed,
                                                  current: readingDayRecipeId == recipe.id)
                }
                result.append(contentsOf: [
                    .offset(30.scale),
                    .recipes(recipes)
                ])
                
                let goodStartProgress = self.goodStartProgress(readingRecipes: readingRecipesAtChallenge)
                let completeDay3Progress = self.completeDay3Progress(readingRecipes: readingRecipesAtChallenge)
                let completeChallengeProgress = self.completeChallengeProgress(readingRecipes: readingRecipesAtChallenge,
                                                                               challengeRecipesCount: challenge.recipes.count)
                let badges = ChallengeBadgesElement(goodStartProgress: goodStartProgress,
                                                    completeDay3Progress: completeDay3Progress,
                                                    completeChallengeProgress: completeChallengeProgress)
                result.append(contentsOf: [
                    .offset(30.scale),
                    .badges(badges)
                ])
                
                return result
            }
    }
    
    func makeChallenge() -> Driver<Challenge> {
        challengeId
            .flatMapLatest { [weak self] challengeId -> Observable<Challenge> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Challenge> {
                    self.contentManager
                        .obtainChallenge(id: challengeId)
                        .flatMap { challenge -> Single<Challenge> in
                            guard let challenge = challenge else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(challenge)
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
        
        let updated = ContentMediator.shared
            .recipeReadingProgressUpdated
            .flatMapLatest { [weak self] recipe -> Driver<[RecipeReadingProgress]> in
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

// MARK: Private (Additional)
private extension ChallengeViewModel {
    func isCompleteChallenge(readingRecipes: [RecipeReadingProgress], challengeRecipesCount: Int) -> Bool {
        completeChallengeProgress(readingRecipes: readingRecipes, challengeRecipesCount: challengeRecipesCount) == 100
    }
    
    func readingDayRecipeId(readingRecipes: [RecipeReadingProgress], challengeRecipes: [RecipeCover]) -> Int? {
        guard !readingRecipes.isEmpty else {
            return challengeRecipes.first?.id
        }
        
        let lastChallengeRecipeIndex = challengeRecipes.lastIndex(where: { recipe -> Bool in
            readingRecipes.contains(where: { $0.recipe.id == recipe.id })
        })
        guard let lastChallengeRecipeIndex = lastChallengeRecipeIndex else {
            return challengeRecipes.first?.id
        }
        
        guard let progress = readingRecipes.first(where: { $0.recipe.id == challengeRecipes[lastChallengeRecipeIndex].id })?.progress else {
            return challengeRecipes.first?.id
        }
        
        if progress < 1 {
            return challengeRecipes[lastChallengeRecipeIndex].id
        } else {
            let nextIndex = lastChallengeRecipeIndex + 1
            if challengeRecipes.indices.contains(nextIndex) {
                return challengeRecipes[nextIndex].id
            }
        }
        
        return nil
    }
    
    func goodStartProgress(readingRecipes: [RecipeReadingProgress]) -> Int {
        guard readingRecipes.count > 0 else {
            return 0
        }
        
        let progress = readingRecipesToProgress(readingRecipes)
        return progress.max() ?? 0
    }
    
    func completeDay3Progress(readingRecipes: [RecipeReadingProgress]) -> Int {
        guard readingRecipes.count > 0 else {
            return 0
        }
        
        let progress = readingRecipesToProgress(readingRecipes)
        
        let totalProgress = progress
            .sorted(by: { $0 > $1 })
            .prefix(3)
            .reduce(0) { $0 + $1 }
        let totalPercent = Float(300)
        
        let percent = Float(totalProgress) / totalPercent * 100
        
        return Int(percent)
    }
    
    func completeChallengeProgress(readingRecipes: [RecipeReadingProgress], challengeRecipesCount: Int) -> Int {
        guard readingRecipes.count > 0 else {
            return 0
        }
        
        let progress = readingRecipesToProgress(readingRecipes)
        
        let totalProgress = progress
            .sorted(by: { $0 > $1 })
            .reduce(0) { $0 + $1 }
        let totalPercent = Float(challengeRecipesCount * 100)
        
        guard totalPercent > 0 else {
            return 0
        }
        
        let percent = Float(totalProgress) / totalPercent * 100
        
        return Int(percent)
    }
    
    func readingRecipesToProgress(_ readingRecipes: [RecipeReadingProgress]) -> [Int] {
        readingRecipes.map { recipe -> Int in
            let readStepsCount = Float(recipe.currentStepIndex + 1)
            let totalStepsCount = Float(recipe.recipe.steps.count)
            let percent = readStepsCount / totalStepsCount * 100
            return Int(percent)
        }
    }
}
