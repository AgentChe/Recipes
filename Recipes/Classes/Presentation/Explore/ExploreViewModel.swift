//
//  ExploreViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import RxSwift
import RxCocoa
import Kingfisher

final class ExploreViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var userSearching = BehaviorRelay(value: false)
    lazy var search = BehaviorRelay(value: "")
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var defaultsElements = makeDefaultElements()
    private lazy var popularRequestsElements = makePopularRequestsElements()
    private lazy var source = makeSource()
    private lazy var exploreKit = makeExploreKit()
    private lazy var categories = makeCategories()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ExploreViewModel {
    enum Source: Equatable {
        case `default`
        case popularRequests
        case search(String)
    }
    
    func makeElements() -> Driver<[ExploreCollectionElement]> {
        Driver
            .combineLatest(defaultsElements, popularRequestsElements, source)
            .flatMapLatest { [weak self] defaultsElements, popularRequestsElements, source -> Driver<[ExploreCollectionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                switch source {
                case .default:
                    return .just(defaultsElements)
                case .popularRequests:
                    return .just(popularRequestsElements)
                case .search(let text):
                    return self.makeSearchElements(text: text)
                }
            }
    }
    
    func makeSource() -> Driver<Source> {
        Driver
            .combineLatest(userSearching.asDriver(),
                           search.asDriver().debounce(RxTimeInterval.milliseconds(500)))
            .map { userSearching, search -> Source in
                guard userSearching else {
                    return .default
                }
                
                return search.isEmpty ? .popularRequests : .search(search)
            }
            .distinctUntilChanged()
    }
    
    func makeDefaultElements() -> Driver<[ExploreCollectionElement]> {
        Driver
            .combineLatest(categories, exploreKit)
            .map { categories, kit -> [ExploreCollectionElement] in
                var result = [ExploreCollectionElement]()
                
                result.append(contentsOf: [
                    .title("Explore.ExploreCategories".localized, large: true),
                    .verticalOffset(16.scale),
                    .categories(categories),
                    .verticalOffset(30.scale),
                    .title("Explore.TrendingSearches".localized, large: true)
                ])
                
                if !kit.trendingSearches.isEmpty {
                    kit.trendingSearches.forEach {
                        result.append(.recipe($0))
                    }
                }
                
                return result
            }
    }
    
    func makePopularRequestsElements() -> Driver<[ExploreCollectionElement]> {
        exploreKit
            .map { kit -> [ExploreCollectionElement] in
                var result = [ExploreCollectionElement]()
                
                result.append(contentsOf: [
                    .title("Explore.PopularRequests".localized, large: false),
                    .verticalOffset(30.scale)
                ])
                
                kit.popularRequests.enumerated().forEach { index, request in
                    result.append(.popularRequest(request))
                    
                    if (kit.popularRequests.count - 1) != index {
                        result.append(contentsOf: [
                            .verticalOffset(20.scale),
                            .separator,
                            .verticalOffset(20.scale)
                        ])
                    }
                }
                
                return result
            }
    }
    
    func makeSearchElements(text: String) -> Driver<[ExploreCollectionElement]> {
        func source() -> Single<[ExploreCollectionElement]> {
            contentManager
                .searchRecipes(at: text)
                .map { recipes -> [ExploreCollectionElement] in
                    recipes.map { .recipe($0) }
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
            .trackActivity(activity)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeExploreKit() -> Driver<ExploreKit> {
        func source() -> Single<ExploreKit> {
            contentManager
                .obtainExploreKit()
                .flatMap { kit -> Single<ExploreKit> in
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

        return self.observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
