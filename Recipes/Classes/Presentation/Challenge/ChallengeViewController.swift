//
//  ChallengeViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import UIKit
import RxSwift

final class ChallengeViewController: UIViewController {
    lazy var mainView = ChallengeView()
    
    private let viewModel: ChallengeViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(challengeId: Int) {
        viewModel = ChallengeViewModel(challengeId: challengeId)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Challenge Screen")
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.progress
            .drive(Binder(mainView.progressView) { base, progress in
                base.setup(progress: progress)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension ChallengeViewController {
    static func make(challengeId: Int) -> ChallengeViewController {
        let vc = ChallengeViewController(challengeId: challengeId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: ChallengeTableDelegate
extension ChallengeViewController: ChallengeTableDelegate {
    // TODO: Impl
    func challengeTableDidTappedCook(recipeId: Int) {
//        let vc = RecipeViewController.make(recipeId: recipeId)
//        present(vc, animated: true)
    }
    
    // TODO: Impl
    func challengeTableDidTapped(element: ChallengeRecipeElement) {
//        let vc: UIViewController
//
//        let needPayment = !SessionManager().hasActiveSubscriptions()
//        if needPayment && element.recipe.paid {
//            vc = PaygateViewController.make()
//        } else {
//            vc = RecipeViewController.make(recipeId: element.recipe.id)
//        }
//
//        present(vc, animated: true)
    }
}

// MARK: Private
private extension ChallengeViewController {
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
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
