//
//  ContentManager.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import Foundation

protocol ContentManagerProtocol: AnyObject {
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]>
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]>
    func obtainDiets(forceUpdate: Bool) -> Single<[Category]>
    func obtainForYouKit() -> Single<ForYouKit?>
    func save(recipe: RecipeCover) -> Single<Bool>
    func removeSaved(recipe: RecipeCover) -> Single<Bool>
    func obtainSavedRecipesCover() -> Single<[RecipeCover]>
    func obtainExploreKit() -> Single<[RecipeCover]>
    func searchRecipes(at: String) -> Single<[RecipeCover]>
    func obtainCategoryRecipesCover(categoryId: Int) -> Single<[RecipeCover]>
    func obtainRankingRecipesCover(rankingId: Int) -> Single<[RecipeCover]>
    func obtainReadingRecipes() -> Single<[RecipeReadingProgress]>
    func set(recipeReadingProgress: RecipeReadingProgress) -> Single<Void>
    func removeRecipeProgress(recipeId: Int) -> Single<Void>
    func obtainShoppings() -> Single<[Shopping]>
    func set(shopping: Shopping) -> Single<Void>
    func removeShopping(recipeId: Int) -> Single<Void>
    func removeAllShoppings() -> Single<Void>
    func feedback(recipeId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?) -> Single<Bool>
    func obtainRecipeKit(recipeId: Int) -> Single<RecipeKit?>
}

final class ContentManager: ContentManagerProtocol {
    enum Constants {
        static let categoriesKey = "content_manager_categories_key"
        static let rankingKey = "content_manager_ranking_key"
        static let dietsKey = "content_manager_diets_key"
        static let readingRecipesKey = "content_manager_reading_recipes_key"
        static let shoppingsKey = "content_manager_shoppings_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension ContentManager {
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]> {
        forceUpdate ? loadCategories() : cachedCategories()
    }
    
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]> {
        forceUpdate ? loadRankings() : cachedRankings()
    }
    
    func obtainDiets(forceUpdate: Bool) -> Single<[Category]> {
        forceUpdate ? loadDiets() : cachedDiets()
    }
    
    func obtainForYouKit() -> Single<ForYouKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetForYouRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetForYouResponse.map(from: $0) }
    }
    
    func save(recipe: RecipeCover) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveRecipeRequest(userToken: userToken, recipeId: recipe.id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { respone in return true }
            .do(onSuccess: { success in
                if success {
                    ContentMediator.shared.notifyAboutSaved(recipe: recipe)
                }
            })
    }
    
    func removeSaved(recipe: RecipeCover) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = RemoveSavedRecipeRequest(userToken: userToken, recipeId: recipe.id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { respone in return true }
            .do(onSuccess: { success in
                if success {
                    ContentMediator.shared.notifyAboutRemoveSaved(recipe: recipe)
                }
            })
    }
    
    func obtainSavedRecipesCover() -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetSavedRecipesRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSavedRecipesResponse.map(from: $0) }
    }
    
    func obtainExploreKit() -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetExploreKitRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetExploreKitResponse.map(from: $0) }
    }
    
    func searchRecipes(at: String) -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = SearchRecipesRequest(userToken: userToken, search: at)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SearchRecipesResponse.map(from: $0) }
    }
    
    func obtainCategoryRecipesCover(categoryId: Int) -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetCategoryRecipesRequest(userToken: userToken, categoryId: categoryId)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCategoryRecipesResponse.map(from: $0) }
    }
    
    func obtainRankingRecipesCover(rankingId: Int) -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetRankingRecipesRequest(userToken: userToken, rankingId: rankingId)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRankingRecipesResponse.map(from: $0) }
    }
    
    func obtainReadingRecipes() -> Single<[RecipeReadingProgress]> {
        Single<[RecipeReadingProgress]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.readingRecipesKey),
                let recipes = try? JSONDecoder().decode([RecipeReadingProgress].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }

            event(.success(recipes))

            return Disposables.create()
        }
    }
    
    func set(recipeReadingProgress: RecipeReadingProgress) -> Single<Void> {
        obtainReadingRecipes()
            .flatMap { readingRecipes -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingRecipes
                    
                    if let index = result.firstIndex(where: { $0.recipe.id == recipeReadingProgress.recipe.id }) {
                        result[index] = recipeReadingProgress
                    } else {
                        result.append(recipeReadingProgress)
                    }
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.readingRecipesKey)
                        
                        ContentMediator.shared.notifyAboutUpdate(recipeReadingProgress: recipeReadingProgress)
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func removeRecipeProgress(recipeId: Int) -> Single<Void> {
        obtainReadingRecipes()
            .flatMap { readingRecipes -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingRecipes
                    
                    if let index = result.firstIndex(where: { $0.recipe.id == recipeId }) {
                        result.remove(at: index)
                        
                        if let data = try? JSONEncoder().encode(result) {
                            UserDefaults.standard.set(data, forKey: Constants.readingRecipesKey)
                            
                            ContentMediator.shared.notifyAboutUpdateRemovedProgress(recipeId: recipeId)
                        }
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func obtainShoppings() -> Single<[Shopping]> {
        Single<[Shopping]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.shoppingsKey),
                let shoppings = try? JSONDecoder().decode([Shopping].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }

            event(.success(shoppings))

            return Disposables.create()
        }
    }
    
    func set(shopping: Shopping) -> Single<Void> {
        obtainShoppings()
            .flatMap { shoppings -> Single<Void> in
                Single<Void>.create { event in
                    var result = shoppings
                    
                    if let index = result.firstIndex(where: { $0.recipe.id == shopping.recipe.id }) {
                        result[index] = shopping
                    } else {
                        result.append(shopping)
                    }
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.shoppingsKey)
                        
                        ContentMediator.shared.notifyAboutUpdate(shopping: shopping)
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func removeShopping(recipeId: Int) -> Single<Void> {
        obtainShoppings()
            .flatMap { shoppings -> Single<Void> in
                Single<Void>.create { event in
                    var result = shoppings
                    
                    if let index = result.firstIndex(where: { $0.recipe.id == recipeId }) {
                        result.remove(at: index)
                        
                        if let data = try? JSONEncoder().encode(result) {
                            UserDefaults.standard.set(data, forKey: Constants.shoppingsKey)
                            
                            ContentMediator.shared.notifyAboutRemovedShopping(recipeId: recipeId)
                        }
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func removeAllShoppings() -> Single<Void> {
        Single<Void>.create { event in
            UserDefaults.standard.removeObject(forKey: Constants.shoppingsKey)
            
            ContentMediator.shared.notifyAboutRemovedAllShoppings()
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func feedback(recipeId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = FeedbackRequest(userToken: userToken,
                                      recipeId: recipeId,
                                      rating: rating,
                                      improves: improves,
                                      whatBetter: whatBetter)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { FeedbackResponse.map(from: $0) }
    }
    
    func obtainRecipeKit(recipeId: Int) -> Single<RecipeKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetRecipeKitRequest(userToken: userToken, recipeId: recipeId)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRecipeKitResponse.map(from: $0) }
    }
}

// MARK: Private
private extension ContentManager {
    func loadCategories() -> Single<[Category]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetCategoriesRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCategoriesResponse.map(from: $0) }
            .do(onSuccess: { categories in
                guard let data = try? JSONEncoder().encode(categories) else {
                    return
                }

                UserDefaults.standard.set(data, forKey: Constants.categoriesKey)
            })
    }
    
    func cachedCategories() -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.categoriesKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let categories = try? JSONDecoder().decode([Category].self, from: data)
                
                event(.success(categories ?? []))
                
                return Disposables.create()
            }
    }
    
    func loadRankings() -> Single<[Ranking]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetRankingRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRankingResponse.map(from: $0) }
            .do(onSuccess: { rankings in
                guard let data = try? JSONEncoder().encode(rankings) else {
                    return
                }

                UserDefaults.standard.set(data, forKey: Constants.rankingKey)
            })
    }
    
    func cachedRankings() -> Single<[Ranking]> {
        Single<[Ranking]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.rankingKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let rankings = try? JSONDecoder().decode([Ranking].self, from: data)
                
                event(.success(rankings ?? []))
                
                return Disposables.create()
            }
    }
    
    func loadDiets() -> Single<[Category]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetDietsRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDietsResponse.map(from: $0) }
            .do(onSuccess: { diets in
                guard let data = try? JSONEncoder().encode(diets) else {
                    return
                }

                UserDefaults.standard.set(data, forKey: Constants.dietsKey)
            })
    }
    
    func cachedDiets() -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.dietsKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let diets = try? JSONDecoder().decode([Category].self, from: data)
                
                event(.success(diets ?? []))
                
                return Disposables.create()
            }
    }
}
