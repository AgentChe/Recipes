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
    func obtainExploreKit() -> Single<ExploreKit?>
    func searchRecipes(at: String) -> Single<[RecipeCover]>
    func obtainCategoryRecipesCover(categoryId: Int) -> Single<[RecipeCover]>
    func obtainRankingRecipesCover(rankingId: Int) -> Single<[RecipeCover]>
    func obtainReadingRecipes() -> Single<[RecipeReadingProgress]>
    func set(recipeReadingProgress: RecipeReadingProgress) -> Single<Void>
    func removeRecipeProgress(recipeId: Int) -> Single<Void>
    func feedback(recipeId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?,
                  whatLearn: String?) -> Single<Bool>
    func obtainChallenge(id: Int) -> Single<Challenge?>
}

final class ContentManager: ContentManagerProtocol {
    enum Constants {
        static let categoriesKey = "content_manager_categories_key"
        static let rankingKey = "content_manager_ranking_key"
        static let dietsKey = "content_manager_diets_key"
        static let readingRecipesKey = "content_manager_reading_recipes_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension ContentManager {
    // TODO: remove file
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                let path = Bundle.main.path(forResource: "Categories", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetCategoriesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        forceUpdate ? loadCategories() : cachedCategories()
    }
    
    // TODO: remove file
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]> {
        Single<[Ranking]>
            .create { event in
                let path = Bundle.main.path(forResource: "Rankings", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetRankingResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        forceUpdate ? loadRankings() : cachedRankings()
    }
    
    // TODO: remove file
    func obtainDiets(forceUpdate: Bool) -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                let path = Bundle.main.path(forResource: "Categories", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetCategoriesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        forceUpdate ? loadDiets() : cachedDiets()
    }
    
    // TODO: remove file
    func obtainForYouKit() -> Single<ForYouKit?> {
        Single<ForYouKit?>
            .create { event in
                let path = Bundle.main.path(forResource: "ForYouMock", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetForYouResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetForYouRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetForYouResponse.map(from: $0) }
    }
    
    func save(recipe: RecipeCover) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveRecipeRequest(userToken: userToken, recipeId: recipe.id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SaveRemoveRecipeResponse.map(from: $0) }
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
            .map { SaveRemoveRecipeResponse.map(from: $0) }
            .do(onSuccess: { success in
                if success {
                    ContentMediator.shared.notifyAboutRemoveSaved(recipe: recipe)
                }
            })
    }
    
    // TODO: remove file
    func obtainSavedRecipesCover() -> Single<[RecipeCover]> {
        Single<[RecipeCover]>
            .create { event in
                let path = Bundle.main.path(forResource: "RankingRecipes", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = SearchRecipesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetSavedRecipesRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetSavedRecipesResponse.map(from: $0) }
    }
    
    // TODO: remove file
    func obtainExploreKit() -> Single<ExploreKit?> {
        Single<ExploreKit?>
            .create { event in
                let path = Bundle.main.path(forResource: "Explore", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetExploreKitResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetExploreKitRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetExploreKitResponse.map(from: $0) }
    }
    
    // TODO: remove file
    func searchRecipes(at: String) -> Single<[RecipeCover]> {
        Single<[RecipeCover]>
            .create { event in
                let path = Bundle.main.path(forResource: "RankingRecipes", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = SearchRecipesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = SearchRecipesRequest(userToken: userToken, search: at)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { SearchRecipesResponse.map(from: $0) }
    }
    
    // TODO: remove file
    func obtainCategoryRecipesCover(categoryId: Int) -> Single<[RecipeCover]> {
        Single<[RecipeCover]>
            .create { event in
                let path = Bundle.main.path(forResource: "RankingRecipes", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetRankingRecipesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetCategoryRecipesRequest(userToken: userToken, categoryId: categoryId)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetCategoryRecipesResponse.map(from: $0) }
    }
    
    // TODO: remove file
    func obtainRankingRecipesCover(rankingId: Int) -> Single<[RecipeCover]> {
        Single<[RecipeCover]>
            .create { event in
                let path = Bundle.main.path(forResource: "RankingRecipes", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetRankingRecipesResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetRankingRecipesRequest(userToken: userToken, rankingId: rankingId)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetRankingRecipesResponse.map(from: $0) }
    }
    
    // TODO
    func obtainReadingRecipes() -> Single<[RecipeReadingProgress]> {
        Single<[RecipeReadingProgress]>.create { event in
            let recipes = [
                RecipeReadingProgress(recipe: Recipe(id: 1,
                                                     name: "Poke with salmon",
                                                     imageUrl: URL(string: "https://klopotenko.com/wp-content/uploads/2018/03/tom-yam_siteweb-1-1000x600.jpg?v=1619002096")!,
                                                     author: Author(name: "",
                                                                    photoUrl: URL(string: "https://google.com")!),
                                                     rankingId: 1,
                                                     time: 14,
                                                     audioUrl: URL(string: "https://google.com")!,
                                                     shareLink: URL(string: "https://google.com")!,
                                                     isSaved: true,
                                                     introduction: nil,
                                                     steps: [],
                                                     whatAbout: ""),
                                      currentStepIndex: 2)
            ]
            
            event(.success(recipes))
            
            return Disposables.create()
        }
        
//        Single<[RecipeReadingProgress]>.create { event in
//            guard
//                let data = UserDefaults.standard.data(forKey: Constants.readingRecipesKey),
//                let recipes = try? JSONDecoder().decode([RecipeReadingProgress].self, from: data)
//            else {
//                event(.success([]))
//                return Disposables.create()
//            }
//
//            event(.success(recipes))
//
//            return Disposables.create()
//        }
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
    
    func feedback(recipeId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?,
                  whatLearn: String?) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = FeedbackRequest(userToken: userToken,
                                      recipeId: recipeId,
                                      rating: rating,
                                      improves: improves,
                                      whatBetter: whatBetter,
                                      whatLearn: whatLearn)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { FeedbackResponse.map(from: $0) }
    }
    
    // TODO: remove file
    func obtainChallenge(id: Int) -> Single<Challenge?> {
        Single<Challenge?>
            .create { event in
                let path = Bundle.main.path(forResource: "Challenge", ofType: "json")!
                let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                let result = GetChallengeResponse.map(from: jsonResult)
                
                event(.success(result))
                
                return Disposables.create()
            }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetChallengeRequest(userToken: userToken, challengeId: id)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetChallengeResponse.map(from: $0) }
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
