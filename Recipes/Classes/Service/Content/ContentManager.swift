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
    func obtainReadingRecipes() -> Single<[BookReadingProgress]>
    func set(recipeReadingProgress: BookReadingProgress) -> Single<Void>
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
    
    func obtainSavedRecipesCover() -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSavedRecipesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSavedRecipesResponse.map(from: $0) }
    }
    
    func obtainExploreKit() -> Single<ExploreKit?> {
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
    
    // TODO
    func obtainCategoryRecipesCover(categoryId: Int) -> Single<[RecipeCover]> {
        Single<[RecipeCover]>
            .create { event in
                let recipes = [
                    RecipeCover(id: 1,
                              name: "Poke with salmon 1",
                              time: 10,
                              author: Author(name: "", photoUrl: URL(string: "www.google.com")!),
                              imageUrl: URL(string: "https://img.povar.ru/main/71/a7/1b/ab/salat_quotolivequot_klassicheskii_s_kolbasoi-286788.JPG")!,
                              rankingId: 1,
                              shareLink: URL(string: "www.google.com")!,
                              paid: false),
                    RecipeCover(id: 2,
                              name: "Poke with salmon 2",
                              time: 10,
                              author: Author(name: "", photoUrl: URL(string: "www.google.com")!),
                              imageUrl: URL(string: "https://img.povar.ru/main/71/a7/1b/ab/salat_quotolivequot_klassicheskii_s_kolbasoi-286788.JPG")!,
                              rankingId: 1,
                              shareLink: URL(string: "www.google.com")!,
                              paid: false),
                    RecipeCover(id: 3,
                              name: "Poke with salmon 3",
                              time: 10,
                              author: Author(name: "", photoUrl: URL(string: "www.google.com")!),
                              imageUrl: URL(string: "https://img.povar.ru/main/71/a7/1b/ab/salat_quotolivequot_klassicheskii_s_kolbasoi-286788.JPG")!,
                              rankingId: 1,
                              shareLink: URL(string: "www.google.com")!,
                              paid: false),
                    RecipeCover(id: 4,
                              name: "Poke with salmon 4",
                              time: 10,
                              author: Author(name: "", photoUrl: URL(string: "www.google.com")!),
                              imageUrl: URL(string: "https://img.povar.ru/main/71/a7/1b/ab/salat_quotolivequot_klassicheskii_s_kolbasoi-286788.JPG")!,
                              rankingId: 1,
                              shareLink: URL(string: "www.google.com")!,
                              paid: false),
                    RecipeCover(id: 5,
                              name: "Poke with salmon 5",
                              time: 10,
                              author: Author(name: "", photoUrl: URL(string: "www.google.com")!),
                              imageUrl: URL(string: "https://img.povar.ru/main/71/a7/1b/ab/salat_quotolivequot_klassicheskii_s_kolbasoi-286788.JPG")!,
                              rankingId: 1,
                              shareLink: URL(string: "www.google.com")!,
                              paid: false)
                ]
                event(.success(recipes))
                
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
    
    func obtainRankingRecipesCover(rankingId: Int) -> Single<[RecipeCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetRankingRecipesRequest(userToken: userToken, rankingId: rankingId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRankingRecipesResponse.map(from: $0) }
    }
    
    func obtainReadingRecipes() -> Single<[BookReadingProgress]> {
        Single<[BookReadingProgress]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.readingRecipesKey),
                let recipes = try? JSONDecoder().decode([BookReadingProgress].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(recipes))
            
            return Disposables.create()
        }
    }
    
    func set(recipeReadingProgress: BookReadingProgress) -> Single<Void> {
        obtainReadingRecipes()
            .flatMap { readingRecipes -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingRecipes
                    
                    if let index = result.firstIndex(where: { $0.book.id == recipeReadingProgress.book.id }) {
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
                    
                    if let index = result.firstIndex(where: { $0.book.id == recipeId }) {
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
    
    func obtainChallenge(id: Int) -> Single<Challenge?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetChallengeRequest(userToken: userToken, challengeId: id)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetChallengeResponse.map(from: $0) }
    }
}

// MARK: Private
private extension ContentManager {
    // TODO
    func loadCategories() -> Single<[Category]> {
        Single.create { event in
            let categories = [
                Category(id: 1, name: "Appetizer", imageUrl: URL(string: "www.google.com")!),
                Category(id: 2, name: "Basics", imageUrl: URL(string: "www.google.com")!),
                Category(id: 3, name: "Bread", imageUrl: URL(string: "www.google.com")!),
                Category(id: 4, name: "Breakfast", imageUrl: URL(string: "www.google.com")!),
                Category(id: 5, name: "Brunch", imageUrl: URL(string: "www.google.com")!),
                Category(id: 6, name: "Sandwich", imageUrl: URL(string: "www.google.com")!),
                Category(id: 7, name: "Dessert", imageUrl: URL(string: "www.google.com")!),
                Category(id: 8, name: "Drinks", imageUrl: URL(string: "www.google.com")!),
                Category(id: 9, name: "Dumplings", imageUrl: URL(string: "www.google.com")!),
                Category(id: 10, name: "Entree", imageUrl: URL(string: "www.google.com")!),
                Category(id: 11, name: "Salad", imageUrl: URL(string: "www.google.com")!),
                Category(id: 12, name: "Condiments & Pickles", imageUrl: URL(string: "www.google.com")!),
                Category(id: 13, name: "Side Dish", imageUrl: URL(string: "www.google.com")!),
                Category(id: 14, name: "Snacks", imageUrl: URL(string: "www.google.com")!),
                Category(id: 15, name: "Soups & Stews", imageUrl: URL(string: "www.google.com")!)
            ]
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                event(.success(categories))
            }
            
            return Disposables.create()
        }
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetCategoriesRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetCategoriesResponse.map(from: $0) }
//            .do(onSuccess: { categories in
//                guard let data = try? JSONEncoder().encode(categories) else {
//                    return
//                }
//
//                UserDefaults.standard.set(data, forKey: Constants.categoriesKey)
//            })
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
    
    // TODO
    func loadRankings() -> Single<[Ranking]> {
        Single.create { event in
            let rankings = [
                Ranking(id: 1, name: "Trending"),
                Ranking(id: 2, name: "New recipes"),
                Ranking(id: 3, name: "Top recipes")
            ]
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                event(.success(rankings))
            }
            
            return Disposables.create()
        }
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetRankingRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetRankingResponse.map(from: $0) }
//            .do(onSuccess: { rankings in
//                guard let data = try? JSONEncoder().encode(rankings) else {
//                    return
//                }
//
//                UserDefaults.standard.set(data, forKey: Constants.rankingKey)
//            })
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
    
    // TODO
    func loadDiets() -> Single<[Category]> {
        Single.create { event in
            let diets = [
                Category(id: 1, name: "Dairy-free", imageUrl: URL(string: "www.google.com")!),
                Category(id: 2, name: "Gluten-free", imageUrl: URL(string: "www.google.com")!),
                Category(id: 3, name: "Low sugar", imageUrl: URL(string: "www.google.com")!),
                Category(id: 4, name: "Low-carb", imageUrl: URL(string: "www.google.com")!),
                Category(id: 5, name: "Low-fat", imageUrl: URL(string: "www.google.com")!),
                Category(id: 6, name: "Pescatarian", imageUrl: URL(string: "www.google.com")!),
                Category(id: 7, name: "Vegan", imageUrl: URL(string: "www.google.com")!),
                Category(id: 8, name: "Vegetarian", imageUrl: URL(string: "www.google.com")!),
                Category(id: 9, name: "None of these", imageUrl: URL(string: "www.google.com")!)
            ]
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                event(.success(diets))
            }
            
            return Disposables.create()
        }
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetDietsRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetDietsResponse.map(from: $0) }
//            .do(onSuccess: { diets in
//                guard let data = try? JSONEncoder().encode(diets) else {
//                    return
//                }
//
//                UserDefaults.standard.set(data, forKey: Constants.dietsKey)
//            })
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
