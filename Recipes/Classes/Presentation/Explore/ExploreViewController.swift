//
//  ExploreViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import RxSwift

final class ExploreViewController: UIViewController {
    lazy var mainView = ExploreView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ExploreViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Explore Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.searchView.changedState
            .map { $0 == .focus }
            .emit(to: viewModel.userSearching)
            .disposed(by: disposeBag)
        
        mainView.searchView.changedText
            .do(onNext: { text in
                AmplitudeManager.shared
                    .logEvent(name: "Explore Tap", parameters: ["what": "search"])
            })
            .emit(to: viewModel.search)
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.didScroll
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        mainView.rx.keyboardHeight
            .bind(to: Binder(mainView.collectionView) { base, keyboardHeight in
                base.contentInset.bottom = keyboardHeight > 0 ? keyboardHeight : 30.scale
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.mainDelegate = self
    }
}

// MARK: Make
extension ExploreViewController {
    static func make() -> ExploreViewController {
        let vc = ExploreViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ExploreCollectionDelegate
extension ExploreViewController: ExploreCollectionDelegate {
    func exploreCollectionDidTapped(category: Category) {
        AmplitudeManager.shared
            .logEvent(name: "Explore Tap", parameters: ["what": "categories"])
        
        let vc = CategoryViewController.make(category: category)
        present(vc, animated: true)
    }
    
    func exploreCollectionDidTapped(recipe: RecipeCover) {
        let vc: UIViewController
        
        let needPayment = !SessionManager().hasActiveSubscriptions()
        if needPayment && recipe.paid {
            vc = PaygateViewController.make()
        } else {
            vc = RecipeViewController.make(recipeId: recipe.id)
        }
        
        present(vc, animated: true)
    }
    
    func exploreCollectionDidTapped(popularRequest: String) {
        mainView.searchView.setup(popularRequest: popularRequest)
    }
}

// MARK: Private
private extension ExploreViewController {
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
        mainView.collectionView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
