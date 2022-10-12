//
//  RecipeTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

protocol RecipeTableDelegate: AnyObject {
    func recipeTableDidTappedShopping()
    func recipeTableDidTapped(step: RecipeStep)
    func recipeTableDidTappedSeeAll()
    func recipeTableDidTapped(recipe: RecipeCover)
    func recipeTableDidTapped(category: Category)
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
        case .shopping(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeShoppingButtonCell.self)) as! RecipeShoppingButtonCell
            cell.setup(element: element)
            return cell
        case .step(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeStepCell.self)) as! RecipeStepCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: RecipeSeparatorCell.self))!
        case .seeAll:
            return dequeueReusableCell(withIdentifier: String(describing: RecipeSeeAllCell.self))!
        case .cpf(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecipeCPFCell.self)) as! RecipeCPFCell
            cell.setup(element: element)
            return cell
        case .recipes(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouRecipesCell.self)) as! ForYouRecipesCell
            cell.backgroundColor = Appearance.background
            cell.contentView.backgroundColor = Appearance.background
            cell.setup(elements: elements, tapped: { [weak self] recipe in
                self?.mainDelegate?.recipeTableDidTapped(recipe: recipe)
            })
            return cell
        case .categories(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouCategoriesCell.self)) as! ForYouCategoriesCell
            cell.backgroundColor = Appearance.background
            cell.contentView.backgroundColor = Appearance.background
            cell.setup(elements: elements, tapped: { [weak self] category in
                self?.mainDelegate?.recipeTableDidTapped(category: category)
            })
            return cell
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
        case .cpf:
            return 114.scale
        case .recipes:
            return 221.scale
        case .categories:
            return 56.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .ingredient(let element):
            element.marked.toggle()
            reloadData()
            
            mainDelegate?.recipeTableDidTappedShopping()
        case .shopping(let element):
            let allSelected = element.allSelected
            element.elements.forEach { $0.marked = !allSelected }
            reloadData()
            
            mainDelegate?.recipeTableDidTappedShopping()
        case .step(let element):
            mainDelegate?.recipeTableDidTapped(step: element.step)
        case .seeAll:
            mainDelegate?.recipeTableDidTappedSeeAll()
        default:
            break
        }
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
        register(RecipeCPFCell.self, forCellReuseIdentifier: String(describing: RecipeCPFCell.self))
        register(ForYouRecipesCell.self, forCellReuseIdentifier: String(describing: ForYouRecipesCell.self))
        register(ForYouCategoriesCell.self, forCellReuseIdentifier: String(describing: ForYouCategoriesCell.self))
        
        dataSource = self
        delegate = self
    }
}
