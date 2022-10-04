//
//  ForYouTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

protocol ForYouTableDelegate: AnyObject {
    func forYouTableDidTapped(recipe: RecipeCover)
    func forYouTableDidTapped(challenge: ChallengeCover)
    func forYouTableDidTapped(ranking: Ranking)
    func forYouTableDidTapped(category: Category)
}

final class ForYouTableView: UITableView {
    weak var mainDelegate: ForYouTableDelegate?
    
    private lazy var elements = [ForYouTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouTableView {
    func setup(elements: [ForYouTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ForYouTableView: UITableViewDataSource {
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
        case .freeRecipe(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouFreeRecipeCell.self)) as! ForYouFreeRecipeCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouTitleCell.self)) as! ForYouTitleCell
            cell.setup(title: element, seeAllHidden: true)
            return cell
        case .recipes(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouRecipesCell.self)) as! ForYouRecipesCell
            cell.setup(elements: elements, tapped: { [weak self] recipe in
                self?.mainDelegate?.forYouTableDidTapped(recipe: recipe)
            })
            return cell
        case .challenges(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouChallengesCell.self)) as! ForYouChallengesCell
            cell.setup(elements: elements, tapped: { [weak self] challenge in
                self?.mainDelegate?.forYouTableDidTapped(challenge: challenge)
            })
            return cell
        case .rankingTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouTitleCell.self)) as! ForYouTitleCell
            cell.setup(title: element.name, seeAllHidden: false)
            return cell
        case .rankingRecipe(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouRankingCell.self)) as! ForYouRankingCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: ForYouSeparatorCell.self))!
        case .categories(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouCategoriesCell.self)) as! ForYouCategoriesCell
            cell.setup(elements: elements, tapped: { [weak self] category in
                self?.mainDelegate?.forYouTableDidTapped(category: category)
            })
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ForYouTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .freeRecipe:
            return 340.scale
        case .title, .rankingTitle:
            return 24.scale
        case .recipes:
            return 221.scale
        case .challenges:
            return 284.scale
        case .rankingRecipe:
            return 65.scale
        case .separator:
            return 1.scale
        case .categories:
            return 56.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .freeRecipe(let element):
            mainDelegate?.forYouTableDidTapped(recipe: element)
        case .rankingRecipe(let element):
            mainDelegate?.forYouTableDidTapped(recipe: element)
        case .rankingTitle(let element):
            mainDelegate?.forYouTableDidTapped(ranking: element)
        default:
            break
        }
    }
}

// MARK: Private
private extension ForYouTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ForYouFreeRecipeCell.self, forCellReuseIdentifier: String(describing: ForYouFreeRecipeCell.self))
        register(ForYouTitleCell.self, forCellReuseIdentifier: String(describing: ForYouTitleCell.self))
        register(ForYouRecipesCell.self, forCellReuseIdentifier: String(describing: ForYouRecipesCell.self))
        register(ForYouChallengesCell.self, forCellReuseIdentifier: String(describing: ForYouChallengesCell.self))
        register(ForYouRankingCell.self, forCellReuseIdentifier: String(describing: ForYouRankingCell.self))
        register(ForYouSeparatorCell.self, forCellReuseIdentifier: String(describing: ForYouSeparatorCell.self))
        register(ForYouCategoriesCell.self, forCellReuseIdentifier: String(describing: ForYouCategoriesCell.self))
        
        dataSource = self
        delegate = self
    }
}
