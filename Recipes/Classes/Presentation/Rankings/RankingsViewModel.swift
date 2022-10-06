//
//  RankingsViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import RxSwift
import RxCocoa

final class RankingsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let selectRanking: BehaviorRelay<Ranking?>
    
    lazy var recipesElements = makeRecipesElements()
    lazy var rankingsElements = makeRankingsElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var recipes = makeRecipes()
    private lazy var rankings = makeRankings()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(start: Ranking?) {
        selectRanking = BehaviorRelay(value: start)
    }
}

// MARK: Private
private extension RankingsViewModel {
    func makeRecipesElements() -> Driver<[RRecipesTableElement]> {
        recipes
            .map { recipes -> [RRecipesTableElement] in
                var result = [RRecipesTableElement]()
                
                recipes.enumerated().forEach { index, recipe in
                    let element = RRecipesTableRecipeElement(number: String(index + 1),
                                                         recipe: recipe)
                    result.append(.recipe(element))
                    
                    if (recipes.count - 1) != index {
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
    
    func makeRankingsElements() -> Driver<[RankingsCollectionElement]> {
        Driver
            .combineLatest(selectRanking.asDriver(), rankings)
            .map { selectRanking, rankings -> [RankingsCollectionElement] in
                rankings.map { ranking -> RankingsCollectionElement in
                    RankingsCollectionElement(ranking: ranking,
                                              isSelected: ranking.id == selectRanking?.id)
                }
            }
    }
    
    func makeRecipes() -> Driver<[RecipeCover]> {
        selectRanking
            .compactMap { $0 }
            .flatMapLatest { [weak self] selectedRanking -> Observable<[RecipeCover]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[RecipeCover]> {
                    self.contentManager
                        .obtainRankingRecipesCover(rankingId: selectedRanking.id)
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
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRankings() -> Driver<[Ranking]> {
        contentManager
            .obtainRankings(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
