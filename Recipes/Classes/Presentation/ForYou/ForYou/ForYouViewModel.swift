//
//  ForYouViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import RxSwift
import RxCocoa

final class ForYouViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var rankings = makeRankings()
    private lazy var categories = makeCategories()
    private lazy var forYouKit = makeForYouKit()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ForYouViewModel {
    func makeElements() -> Driver<[ForYouTableElement]> {
        Driver
            .combineLatest(rankings, categories, forYouKit)
            .map { [weak self] rankings, categories, kit -> [ForYouTableElement] in
                guard let self = self else {
                    return []
                }
                
                var result = [ForYouTableElement]()
                
                let freeRecipe = ForYouTableElement.freeRecipe(kit.freeRecipe)
                result.append(freeRecipe)
                
                if !kit.todaysHotSummaries.isEmpty {
                    result.append(contentsOf: [
                        .offset(30.scale),
                        .title("ForYou.TodayHotSummaries".localized),
                        .offset(16.scale),
                        .recipes(kit.todaysHotSummaries)
                    ])
                }
                
                if !kit.youMayLike.isEmpty {
                    result.append(contentsOf: [
                        .offset(30.scale),
                        .title("ForYou.YouMayLike".localized),
                        .offset(16.scale),
                        .recipes(kit.youMayLike)
                    ])
                }
                
                var kitRankings = kit.rankings
                
                if !kitRankings.isEmpty {
                    let kitRanking = kitRankings.removeFirst()
                    let elements = self.rankingElements(from: kitRanking, rankings: rankings)
                    result.append(contentsOf: elements)
                }
                
                if !categories.isEmpty {
                    result.append(contentsOf: [
                        .offset(30.scale),
                        .title("ForYou.ExploreCategories".localized),
                        .offset(16.scale),
                        .categories(categories)
                    ])
                }
                
                kitRankings.forEach { kitRanking in
                    guard let ranking = rankings.first(where: { $0.id == kitRanking.rankingId }) else {
                        return
                    }
                    
                    result.append(contentsOf: [
                        .offset(30.scale),
                        .rankingTitle(ranking),
                        .offset(16.scale),
                        .recipes(kitRanking.recipes)
                    ])
                }
                
                return result
        }
    }
    
    func rankingElements(from group: RankingRecipesGroup, rankings: [Ranking]) -> [ForYouTableElement] {
        guard !group.recipes.isEmpty else {
            return []
        }
        
        var result = [ForYouTableElement]()
        
        if let forYouRanking = rankings.first(where: { $0.id == group.rankingId }) {
            result.append(contentsOf: [
                .offset(24.scale),
                .rankingTitle(forYouRanking),
                .offset(24.scale)
            ])
            
            group.recipes.enumerated().forEach { index, recipe in
                result.append(.rankingRecipe(recipe))
                
                if (group.recipes.count - 1) != index {
                    result.append(contentsOf: [
                        .offset(16.scale),
                        .separator,
                        .offset(16.scale)
                    ])
                }
            }
        }
        
        return result
    }
    
    func makeRankings() -> Driver<[Ranking]> {
        contentManager
            .obtainRankings(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeForYouKit() -> Driver<ForYouKit> {
        func source() -> Single<ForYouKit> {
            contentManager
                .obtainForYouKit()
                .flatMap { kit -> Single<ForYouKit> in
                    guard let kit = kit else {
                        return .error(ContentError(.notContent))
                    }
                    
                    return .just(kit)
                }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorDriveWith: .never())
    }
}
