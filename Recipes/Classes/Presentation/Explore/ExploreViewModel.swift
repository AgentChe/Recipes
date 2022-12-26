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
    private lazy var source = makeSource()
    private lazy var defaultCovers = makeDefaultCovers()
    private lazy var categories = makeCategories()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ExploreViewModel {
    enum Source: Equatable {
        case `default`
        case search(String)
        case empty
    }
    
    func makeElements() -> Driver<[ExploreCollectionElement]> {
        Driver
            .combineLatest(defaultsElements, source)
            .flatMapLatest { [weak self] defaultsElements, source -> Driver<[ExploreCollectionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                switch source {
                case .default:
                    return .just(defaultsElements)
                case .search(let text):
                    return self.makeSearchElements(text: text)
                case .empty:
                    return .just([])
                }
            }
    }
    
    func makeSource() -> Driver<Source> {
        Driver
            .combineLatest(userSearching.asDriver(),
                           search.asDriver().debounce(RxTimeInterval.milliseconds(1000)))
            .map { userSearching, search -> Source in
                guard userSearching else {
                    return .default
                }
                
                return search.isEmpty ? .empty : .search(search)
            }
            .distinctUntilChanged()
    }
    
    func makeDefaultElements() -> Driver<[ExploreCollectionElement]> {
        Driver
            .combineLatest(categories, defaultCovers)
            .map { categories, defaultCovers -> [ExploreCollectionElement] in
                var result = [ExploreCollectionElement]()
                
                result.append(contentsOf: [
                    .title("Explore.ExploreCategories".localized, large: true),
                    .verticalOffset(16.scale),
                    .categories(categories),
                    .verticalOffset(30.scale),
                    .title("Explore.TrendingSearches".localized, large: true)
                ])
                
                if !defaultCovers.isEmpty {
                    defaultCovers.forEach {
                        result.append(.recipe($0))
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
    
    func makeDefaultCovers() -> Driver<[RecipeCover]> {
        func source() -> Single<[RecipeCover]> {
            contentManager
                .obtainExploreKit()
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
