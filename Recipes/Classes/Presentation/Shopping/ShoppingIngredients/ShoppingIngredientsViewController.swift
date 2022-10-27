//
//  ShoppingIngredientsViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.10.2022.
//

import UIKit
import RxSwift

final class ShoppingIngredientsViewController: UIViewController {
    lazy var mainView = ShoppingIngredientsView()
    
    private let viewModel: ShoppingIngredientsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(shopping: Shopping) {
        viewModel = ShoppingIngredientsViewModel(shopping: shopping)
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Public
extension ShoppingIngredientsViewController {
    static func make(shopping: Shopping) -> ShoppingIngredientsViewController {
        let vc = ShoppingIngredientsViewController(shopping: shopping)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = shopping.recipe.name
        return vc
    }
}

// MARK: ShoppingIngredientsTableDelegate
extension ShoppingIngredientsViewController: ShoppingIngredientsTableDelegate {
    func shoppingTableDidTapped(ingredient: (ShoppingIngredientsTableIngredientElement)) {
        viewModel.didTapMarkIngredient.accept(ingredient.ingredient)
    }
    
    func shoppingTableDidTappedRemove(ingredient: (ShoppingIngredientsTableIngredientElement)) {
        viewModel.didTapRemoveIngredient.accept(ingredient.ingredient)
    }
    
    func shoppingTableDidTappedRemoveAllIngredients() {
        viewModel.didTapRemoveAllShoppings.accept(Void())
    }
}
