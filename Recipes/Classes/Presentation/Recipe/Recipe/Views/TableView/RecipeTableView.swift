//
//  RecipeTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

protocol RecipeTableDelegate: AnyObject {
    
}

final class RecipeTableView: UITableView {
    weak var mainDelegate: RecipeTableDelegate?
    
    private lazy var elements = [RecipeTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Pubic
extension RecipeTableView {
    func setup(elements: [RecipeTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension RecipeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = Appearance.background
            cell.contentView.backgroundColor = Appearance.background
            cell.selectionStyle = .none
            return cell
        case .transparent:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .info(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeTableInfoCell.self)) as! RecipeTableInfoCell
            cell.setup(element: element)
            return cell
        case .time(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeTableTimeCell.self)) as! RecipeTableTimeCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeTitleCell.self)) as! RecipeTitleCell
            cell.setup(element: element)
            return cell
        case .ingredient(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeIngredientCell.self)) as! RecipeIngredientCell
            cell.setup(element: element)
            return cell
        case .shopping:
            return dequeueReusableCell(withIdentifier: String(describing: RecipeShoppingButtonCell.self))!
        case .step(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeStepCell.self)) as! RecipeStepCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: RecipeSeparatorCell.self))!
        case .seeAll:
            return dequeueReusableCell(withIdentifier: String(describing: RecipeSeeAllCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension RecipeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .transparent:
            return 373.scale
        case .time:
            return 24.scale
        case .shopping, .seeAll:
            return 53.scale
        case .step:
            return 60.scale
        case .separator:
            return 1.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: Private
private extension RecipeTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(RecipeTableInfoCell.self, forCellReuseIdentifier: String(describing: RecipeTableInfoCell.self))
        register(RecipeTableTimeCell.self, forCellReuseIdentifier: String(describing: RecipeTableTimeCell.self))
        register(RecipeTitleCell.self, forCellReuseIdentifier: String(describing: RecipeTitleCell.self))
        register(RecipeTitleCell.self, forCellReuseIdentifier: String(describing: RecipeTitleCell.self))
        register(RecipeIngredientCell.self, forCellReuseIdentifier: String(describing: RecipeIngredientCell.self))
        register(RecipeShoppingButtonCell.self, forCellReuseIdentifier: String(describing: RecipeShoppingButtonCell.self))
        register(RecipeStepCell.self, forCellReuseIdentifier: String(describing: RecipeStepCell.self))
        register(RecipeSeparatorCell.self, forCellReuseIdentifier: String(describing: RecipeSeparatorCell.self))
        register(RecipeSeeAllCell.self, forCellReuseIdentifier: String(describing: RecipeSeeAllCell.self))
        
        dataSource = self
        delegate = self
    }
}
