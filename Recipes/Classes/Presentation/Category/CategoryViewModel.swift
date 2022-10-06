//
//  CategoryViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import RxSwift
import RxCocoa

final class CategoryViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let categoryId: BehaviorRelay<Int>
    
    init(categoryId: Int) {
        self.categoryId = BehaviorRelay(value: categoryId)
    }
}

// MARK: Private
private extension CategoryViewModel {
    func makeElements() -> Driver<[RecipeCover]> {
        categoryId
            .flatMapLatest { [weak self] categoryId -> Observable<[RecipeCover]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[RecipeCover]> {
                    self.contentManager
                        .obtainCategoryRecipesCover(categoryId: categoryId)
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
}
