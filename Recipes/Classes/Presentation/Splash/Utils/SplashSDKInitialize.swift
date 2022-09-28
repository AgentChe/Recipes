//
//  SplashSDKInitialize.swift
//  Recipes
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import RxSwift
import RxCocoa
import UIKit
import RushSDK

final class SplashSDKInitialize {
    enum Progress {
        case error, initializing, complete
    }
    
    private var handler: ((Progress) -> Void)?
    
    private lazy var disposeBag = DisposeBag()
    private var combineDisposable: Disposable?
    
    private lazy var refreshRushProviderTrigger = PublishRelay<Void>()
    
    private lazy var validationObserver = SplashReceiptValidationObserver()
    
    private lazy var initializeCompleted = combine()
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController) {
        self.vc = vc
    }
}

// MARK: Public
extension SplashSDKInitialize {
    func initialize(handler: @escaping ((Progress) -> Void)) {
        self.handler = handler
        
        send(progress: .initializing)
        
        combineDisposable?.dispose()
        
        combineDisposable = initializeCompleted
            .emit(onNext: { [weak self] successInitializeSDK in
                guard let self = self else {
                    return
                }

                if successInitializeSDK {
                    self.send(progress: .complete)
                } else {
                    self.send(progress: .error)
                    self.openError()
                }
            })
    }
}

// MARK: Private
private extension SplashSDKInitialize {
    func combine() -> Signal<Bool> {
        let rushSDKComplete = makeRushSDKComplete()
        let validationObserve = makeValidationObserve()
        
        return Signal.combineLatest(validationObserve, rushSDKComplete)
            .map { $0 && $1 }
    }
    
    func makeRushSDKComplete() -> Signal<Bool> {
        let refresh = refreshRushProviderTrigger
            .flatMapLatest { _ -> Single<Bool> in
                Single<Bool>
                    .create { event in
                        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                            event(.success(false))
                            return Disposables.create()
                        }
                        
                        delegate.sdkProvider.refreshInstallUserToken { success in
                            event(.success(success))
                        }
                        
                        return Disposables.create()
                    }
            }
            .asSignal(onErrorJustReturn: false)
        
        let initialize = Single<Bool>
            .create { [weak self] event in
                guard let self = self, let delegate = UIApplication.shared.delegate as? AppDelegate else {
                    event(.success(false))
                    return Disposables.create()
                }
                
                let settings = SDKSettings(backendBaseUrl: GlobalDefinitions.rushSDKHost,
                                           backendApiKey: GlobalDefinitions.rushSDKApiKey,
                                           amplitudeApiKey: nil,
                                           appsFlyerApiKey: nil,
                                           facebookActive: false,
                                           branchActive: false,
                                           firebaseActive: false,
                                           applicationTag: GlobalDefinitions.applicationTag,
                                           userToken: SessionManager().getSession()?.userToken,
                                           userId: nil,
                                           view: self.vc?.view,
                                           shouldAddStorePayment: true,
                                           featureAppBackendUrl: nil,
                                           featureAppBackendApiKey: nil,
                                           appleAppID: GlobalDefinitions.appleAppID)
                
                delegate.sdkProvider.initialize(settings: settings) { success in
                    event(.success(true))
                }
                
                return Disposables.create()
            }
            .asSignal(onErrorSignalWith: .never())
        
        return Signal.merge(initialize, refresh)
    }
    
    func makeValidationObserve() -> Signal<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let self = self else {
                    return Disposables.create()
                }
                
                self.validationObserver.observe {
                    event(.success(true))
                }
                
                return Disposables.create()
            }
            .asSignal(onErrorJustReturn: false)
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.send(progress: .initializing)
            self.refreshRushProviderTrigger.accept(Void())
        }
        vc?.present(tryAgainVC, animated: true)
    }
    
    func send(progress: Progress) {
        guard let handler = handler else {
            return
        }
        
        handler(progress)
    }
}
