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
    
    private var combineDisposable: Disposable?
    
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

                self.send(progress: .complete)
            })
    }
}

// MARK: Private
private extension SplashSDKInitialize {
    func combine() -> Signal<Void> {
        let rushSDKComplete = makeRushSDKComplete()
        let validationObserve = makeValidationObserve()
        
        return Signal.zip(validationObserve, rushSDKComplete)
            .map { result in Void() }
    }
    
    func makeRushSDKComplete() -> Signal<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let self = self, let delegate = UIApplication.shared.delegate as? AppDelegate else {
                    event(.success(Void()))
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
                
                delegate.sdkProvider.initialize(settings: settings)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeValidationObserve() -> Signal<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let self = self else {
                    return Disposables.create()
                }
                
                self.validationObserver.observe {
                    event(.success(Void()))
                }
                
                return Disposables.create()
            }
            .asSignal(onErrorJustReturn: Void())
    }
    
    func send(progress: Progress) {
        guard let handler = handler else {
            return
        }
        
        handler(progress)
    }
}
