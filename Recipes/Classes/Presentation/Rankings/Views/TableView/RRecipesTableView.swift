//
//  RRecipesTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit

protocol RRecipesTableDelegate: AnyObject {
    func rankingRecipesTableDidTapped(recipe: RecipeCover)
}

final class RRecipesTableView: UITableView {
    weak var mainDelegate: RRecipesTableDelegate?
    
    private lazy var elements = [RRecipesTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RRecipesTableView {
    func setup(elements: [RRecipesTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension RRecipesTableView: UITableViewDataSource {
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
        case .recipe(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RRecipesTableRecipeCell.self)) as! RRecipesTableRecipeCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: RRecipesTableSeparatorCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension RRecipesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .recipe:
            return 65.scale
        case .separator:
            return 1.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .recipe(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.rankingRecipesTableDidTapped(recipe: element.recipe)
    }
}

// MARK: Private
private extension RRecipesTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(RRecipesTableRecipeCell.self, forCellReuseIdentifier: String(describing: RRecipesTableRecipeCell.self))
        register(RRecipesTableSeparatorCell.self, forCellReuseIdentifier: String(describing: RRecipesTableSeparatorCell.self))
        
        dataSource = self
        delegate = self
    }
}
