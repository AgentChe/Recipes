//
//  FeedbackViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import RxSwift
import RxCocoa

final class FeedbackViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let recipe: BehaviorRelay<Recipe>
    lazy var didSelectRating = PublishRelay<Void>()
    lazy var didTapSubmit = PublishRelay<Void>()
    
    lazy var sended = makeSended()
    lazy var elements = makeElements()
    lazy var submitHidden = makeSubmitHidden()
    lazy var activity = RxActivityIndicator()
    
    private lazy var isSelectedRating = makeIsSelectedRating()
    
    private lazy var collector = BehaviorRelay(value: FeedbackCollector())
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(recipe: Recipe) {
        self.recipe = BehaviorRelay(value: recipe)
    }
}

// MARK: Private
private extension FeedbackViewModel {
    func makeSended() -> Driver<Void> {
        didTapSubmit
            .withLatestFrom(recipe)
            .withLatestFrom(collector) { ($0, $1) }
            .flatMapLatest { [weak self] recipe, collector -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.contentManager
                        .feedback(recipeId: recipe.id,
                                  rating: collector.rating.rating,
                                  improves: collector.improves.improves,
                                  whatBetter: collector.whatBetter.text)
                        .flatMap { success -> Single<Void> in
                            guard success else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(Void())
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
    
    func makeElements() -> Driver<[FeedbackTableElement]> {
        Driver
            .combineLatest(recipe.asDriver(), isSelectedRating)
            .map { [weak self] recipe, isSelectedRating -> [FeedbackTableElement] in
                guard let self = self else {
                    return []
                }
                
                let collector = self.collector.value
                
                var result = [FeedbackTableElement]()
                
                let title = String(format: "Feedback.Title".localized, recipe.name)
                result.append(.recipe(title))
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .rating(collector.rating)
                ])
                
                guard isSelectedRating else {
                    return result
                }
                
                result.append(contentsOf: [
                    .offset(30.scale),
                    .improves(collector.improves)
                ])
                
                result.append(contentsOf: [
                    .offset(30.scale),
                    .whatBetter(collector.whatBetter)
                ])
                
                return result
            }
    }
    
    func makeSubmitHidden() -> Driver<Bool> {
        Driver
            .combineLatest(isSelectedRating, activity) { isSelectedRating, activity -> Bool in
                activity ? true : !isSelectedRating
            }
    }
    
    func makeIsSelectedRating() -> Driver<Bool> {
        didSelectRating
            .map { true }
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
}
