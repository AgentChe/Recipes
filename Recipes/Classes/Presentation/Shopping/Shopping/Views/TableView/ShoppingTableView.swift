//
//  ShoppingTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.10.2022.
//

import UIKit

protocol ShoppingTableDelegate: AnyObject {
    func shoppingTableDidTapped(ingredient: (ShoppingTableIngredientElement))
    func shoppingTableDidTappedRemove(ingredient: (ShoppingTableIngredientElement))
    func shoppingTableDidTappedRemoveAllIngredients()
    func shoppingTableDidTapped(shopping: Shopping)
    func shoppingTableDidTappedMenu(shopping: Shopping)
}

final class ShoppingTableView: UITableView {
    weak var mainDelegate: ShoppingTableDelegate?
    
    private lazy var elements = [ShoppingTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ShoppingTableView {
    func setup(elements: [ShoppingTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ShoppingTableView: UITableViewDataSource {
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
            let cell = dequeueReusableCell(withIdentifier: String(describing: ShoppingTableIngredientCell.self)) as! ShoppingTableIngredientCell
            cell.setup(element: element)
            cell.removeTapped = { [weak self] in
                self?.mainDelegate?.shoppingTableDidTappedRemove(ingredient: element)
            }
            return cell
        case .recipe(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ShoppingTableRecipeCell.self)) as! ShoppingTableRecipeCell
            cell.setup(element: element)
            cell.menuTapped = { [weak self] in
                self?.mainDelegate?.shoppingTableDidTappedMenu(shopping: element)
            }
            return cell
        case .removeAllIngredients:
            return dequeueReusableCell(withIdentifier: String(describing: ShoppingTableRemoveAllCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension ShoppingTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .ingredient:
            return 92.scale
        case .recipe:
            return 89.scale
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
        case .recipe(let element):
            mainDelegate?.shoppingTableDidTapped(shopping: element)
        default:
            return
        }
    }
}

// MARK: Private
private extension ShoppingTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ShoppingTableIngredientCell.self, forCellReuseIdentifier: String(describing: ShoppingTableIngredientCell.self))
        register(ShoppingTableRecipeCell.self, forCellReuseIdentifier: String(describing: ShoppingTableRecipeCell.self))
        register(ShoppingTableRemoveAllCell.self, forCellReuseIdentifier: String(describing: ShoppingTableRemoveAllCell.self))
        
        dataSource = self
        delegate = self
    }
}
