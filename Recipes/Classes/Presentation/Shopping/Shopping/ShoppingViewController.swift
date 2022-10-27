//
//  ShoppingViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import UIKit
import RxSwift

final class ShoppingViewController: UIViewController {
    lazy var mainView = ShoppingView()
    
    private lazy var viewModel = ShoppingViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let discoverRecipesTapped: () -> Void
    
    private init(discoverRecipesTapped: @escaping () -> Void) {
        self.discoverRecipesTapped = discoverRecipesTapped
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.emptyState
            .drive(Binder(self) { base, state in
                base.empty(state: state)
            })
            .disposed(by: disposeBag)
        
        mainView.emptyView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.discoverRecipesTapped()
            })
            .disposed(by: disposeBag)
        
        addFilterActions()
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Public
extension ShoppingViewController {
    static func make(discoverRecipesTapped: @escaping () -> Void) -> ShoppingViewController {
        let vc = ShoppingViewController(discoverRecipesTapped: discoverRecipesTapped)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ShoppingTableDelegate
extension ShoppingViewController: ShoppingTableDelegate {
    func shoppingTableDidTapped(ingredient: (ShoppingTableIngredientElement)) {
        // TODO
    }
    
    func shoppingTableDidTappedRemove(ingredient: (ShoppingTableIngredientElement)) {
        viewModel.didTapRemoveIngredient.accept((ingredient.ingredient, ingredient.shopping))
    }
    
    func shoppingTableDidTappedRemoveAllIngredients() {
        viewModel.didTapRemoveAllShoppings.accept(Void())
    }
    
    func shoppingTableDidTapped(shopping: Shopping) {
        // TODO
    }
    
    func shoppingTableDidTappedMenu(shopping: Shopping) {
        let vc = ShoppingMenuViewController.make { [weak self] result in
            switch result {
            case .delete:
                self?.viewModel.didTapRemoveShopping.accept(shopping)
            case .share:
                self?.share(url: shopping.recipe.shareLink)
            }
        }
        present(vc, animated: false)
    }
}

// MARK: Private
private extension ShoppingViewController {
    func addFilterActions() {
        Observable
            .merge(
                mainView.filterView.allIngredientsButton.rx.tap
                    .map { ShoppingFilterView.Filter.allIngredients },
                
                mainView.filterView.byRecipeButton.rx.tap
                    .map { ShoppingFilterView.Filter.byRecipe }
            )
            .startWith(.allIngredients)
            .bind(to: Binder(self) { base, filter in
                base.mainView.filterView.filter = filter
                base.viewModel.filter.accept(filter)
                base.analytics(filter: filter)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.filterView.allIngredientsButton.rx.tap
                    .map { ShoppingEmptyView.State.allIngredients },
                
                mainView.filterView.byRecipeButton.rx.tap
                    .map { ShoppingEmptyView.State.byRecipe }
            )
            .startWith(.allIngredients)
            .bind(to: Binder(self) { base, state in
                base.mainView.emptyView.update(at: state)
            })
            .disposed(by: disposeBag)
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
    
    func activity(_ activity: Bool) {
        if activity {
            mainView.emptyView.isHidden = true
        }
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func empty(state: ShoppingEmptyView.State?) {
        mainView.emptyView.isHidden = state == nil
        
        guard let state = state else {
            return
        }
        
        mainView.emptyView.update(at: state)
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    func analytics(filter: ShoppingFilterView.Filter) {
        switch filter {
        case .allIngredients:
            AmplitudeManager.shared
                .logEvent(name: "All Ingredients Screen")
        case .byRecipe:
            AmplitudeManager.shared
                .logEvent(name: "By Recipe Screen")
        }
    }
}
