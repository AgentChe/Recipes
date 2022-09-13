//
//  SplashViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    private lazy var viewModel = SplashViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var sdkInitialize = SplashSDKInitialize(vc: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.step()
            .drive(onNext: { [weak self] step in
                guard let self = self else {
                    return
                }
                
                self.activity(state: .none)
                self.goNext(at: step)
            })
            .disposed(by: disposeBag)
        
        sdkInitialize.initialize { [weak self] progress in
            guard let self = self else {
                return
            }
            
            switch progress {
            case .error:
                self.activity(state: .none)
            case .initializing:
                self.activity(state: .sdkInitialize)
            case .complete:
                self.activity(state: .library)
                self.viewModel.validationComplete.accept(Void())
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.animateView.start()
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: PaygateViewControllerDelegate
extension SplashViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        goNext(at: .main)
    }
}

// MARK: Private
private extension SplashViewController {
    func goNext(at step: SplashViewModel.Step) {
        switch step {
        case .onboarding:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = OnboardingViewController.make()
        case .main:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = MainViewController.make()
        case .paygate:
            let vc = PaygateViewController.make()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func activity(state: SplashActivity) {
        state == .none ? mainView.preloader.stopAnimating() : mainView.preloader.startAnimating()
        
        let attrs = TextAttributes()
            .textColor(Appearance.secondary5)
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        mainView.preloaderLabel.attributedText = state.text.attributed(with: attrs)
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
