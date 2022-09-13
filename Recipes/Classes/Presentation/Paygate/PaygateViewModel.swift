//
//  PaygateViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class PaygateViewModel {
    enum Constants {
        static let monthly = "app.books.month"
        static let lifetime = "app.books.forever"
    }
    
    let buy = PublishRelay<String>()
    let restore = PublishRelay<Void>()

    lazy var questionsCount = makeQuestionsCount()
    lazy var products = makeProducts()
    lazy var buyed = makeBuyed()
    lazy var restored = makeRestored()
    
    let activityIndicator = RxActivityIndicator()
    
    private lazy var iapManager = IAPManager()
    private lazy var purchaseInteractor = PaygateInteractor()
    private lazy var profileManager = ProfileManager()
}

// MARK: Private
private extension PaygateViewModel {
    func makeQuestionsCount() -> Driver<Int> {
        .deferred { .just(200) }
    }
    
    func makeProducts() -> Driver<[PaygateProduct]> {
        iapManager
            .obtainPrices(for: [
                Constants.lifetime, Constants.monthly
            ])
            .map { prices -> [PaygateProduct] in
                prices.compactMap { price -> PaygateProduct? in
                    switch price.id {
                    case Constants.lifetime:
                        let lifetimePrice = prices.first(where: { $0.id == Constants.lifetime })
                        let monthlyPrice = prices.first(where: { $0.id == Constants.monthly })
                        
                        guard let lifetimePrice = lifetimePrice, let monthlyPrice = monthlyPrice else {
                            return nil
                        }
                        
                        return PaygateProduct.lifetime(lifetimePrice: lifetimePrice, monthlyPrice: monthlyPrice)
                    case Constants.monthly:
                        let usedProducts = OtterScale.shared.getUsedProducts()
                            .map { $0.appleAppStore } ?? []
                        let withTrial = !usedProducts.contains(PaygateViewModel.Constants.monthly)
                        
                        return PaygateProduct.monthly(price: price, withTrial: withTrial)
                    default:
                        return nil
                    }
                }
            }
            .trackActivity(activityIndicator)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeBuyed() -> Signal<Bool> {
        let purchase = buy
            .flatMapLatest { [weak self] productId -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .buy(productId))
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activityIndicator)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func makeRestored() -> Signal<Bool> {
        let purchase = restore
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .restore)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activityIndicator)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
}
