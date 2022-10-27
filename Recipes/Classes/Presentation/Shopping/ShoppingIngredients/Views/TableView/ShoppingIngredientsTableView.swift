//
//  ShoppingIngredientsTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.10.2022.
//

import UIKit

protocol ShoppingIngredientsTableDelegate: AnyObject {
    func shoppingTableDidTapped(ingredient: (ShoppingIngredientsTableIngredientElement))
    func shoppingTableDidTappedRemove(ingredient: (ShoppingIngredientsTableIngredientElement))
    func shoppingTableDidTappedRemoveAllIngredients()
}

final class ShoppingIngredientsTableView: UITableView {
    weak var mainDelegate: ShoppingIngredientsTableDelegate?
    
    private lazy var elements = [ShoppingIngredientsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ShoppingIngredientsTableView {
    func setup(elements: [ShoppingIngredientsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ShoppingIngredientsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .ingredient(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ShoppingIngredientsCell.self)) as! ShoppingIngredientsCell
            cell.setup(element: element)
            cell.removeTapped = { [weak self] in
                self?.mainDelegate?.shoppingTableDidTappedRemove(ingredient: element)
            }
            return cell
        case .removeAllIngredients:
            return dequeueReusableCell(withIdentifier: String(describing: ShoppingIngredientsRemoveAllCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension ShoppingIngredientsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .ingredient:
            return 92.scale
        case .removeAllIngredients:
            return 53.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .ingredient(let element):
            mainDelegate?.shoppingTableDidTapped(ingredient: element)
        case .removeAllIngredients:
            mainDelegate?.shoppingTableDidTappedRemoveAllIngredients()
        default:
            return
        }
    }
}

// MARK: Private
private extension ShoppingIngredientsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ShoppingIngredientsCell.self, forCellReuseIdentifier: String(describing: ShoppingIngredientsCell.self))
        register(ShoppingIngredientsRemoveAllCell.self, forCellReuseIdentifier: String(describing: ShoppingIngredientsRemoveAllCell.self))
        
        dataSource = self
        delegate = self
    }
}
