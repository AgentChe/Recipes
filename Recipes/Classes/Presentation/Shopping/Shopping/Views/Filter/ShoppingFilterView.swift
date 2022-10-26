//
//  ShoppingFilterView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import UIKit

final class ShoppingFilterView: UIView {
    enum Filter {
        case allIngredients, byRecipe
    }
    
    lazy var filter: Filter = .allIngredients {
        didSet {
            update()
        }
    }
    
    lazy var allIngredientsButton = makeButton(title: "Shopping.AllIngredients".localized)
    lazy var byRecipeButton = makeButton(title: "Shopping.ByRecipe".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ShoppingFilterView {
    func update() {
        allIngredientsButton.marked = filter == .allIngredients
        byRecipeButton.marked = filter == .byRecipe
    }
}

// MARK: Make constraints
private extension ShoppingFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            allIngredientsButton.widthAnchor.constraint(equalToConstant: 108.scale),
            allIngredientsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            allIngredientsButton.topAnchor.constraint(equalTo: topAnchor),
            allIngredientsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            byRecipeButton.widthAnchor.constraint(equalToConstant: 72.scale),
            byRecipeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 144.scale),
            byRecipeButton.topAnchor.constraint(equalTo: topAnchor),
            byRecipeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ShoppingFilterView {
    func makeButton(title: String) -> LibraryFilterButton {
        let view = LibraryFilterButton(title: title)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
