//
//  ExploreCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit

protocol ExploreCollectionDelegate: AnyObject {
    func exploreCollectionDidTapped(category: Category)
    func exploreCollectionDidTapped(recipe: RecipeCover)
    func exploreCollectionDidTapped(popularRequest: String)
}

final class ExploreCollectionView: UICollectionView {
    weak var mainDelegate: ExploreCollectionDelegate?
    
    private lazy var elements = [ExploreCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExploreCollectionView {
    func setup(elements: [ExploreCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ExploreCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .verticalOffset:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = UIColor.clear
            return cell
        case let .title(title, large):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollectionTitleCell.self), for: indexPath) as! ExploreCollectionTitleCell
            cell.setup(title: title, large: large)
            return cell
        case let .categories(element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollectionCategoriesCell.self), for: indexPath) as! ExploreCollectionCategoriesCell
            cell.setup(elements: element) { [weak self] category in
                self?.mainDelegate?.exploreCollectionDidTapped(category: category)
            }
            return cell
        case let .recipe(element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollectionRecipeCell.self), for: indexPath) as! ExploreCollectionRecipeCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollectionSeparatorCell.self), for: indexPath)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ExploreCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .recipe(let element):
            mainDelegate?.exploreCollectionDidTapped(recipe: element)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .verticalOffset(let offset):
            return CGSize(width: 343.scale, height: offset)
        case let .title(_, large):
            return CGSize(width: 343.scale, height: large ? 24.scale : 19.scale)
        case .categories:
            return CGSize(width: 343.scale, height: 56.scale)
        case .recipe:
            return CGSize(width: 163.scale, height: 237.scale)
        case .separator:
            return CGSize(width: 343.scale, height: 1.scale)
        }
    }
}

// MARK: Private
private extension ExploreCollectionView {
    func initialize() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        register(ExploreCollectionTitleCell.self, forCellWithReuseIdentifier: String(describing: ExploreCollectionTitleCell.self))
        register(ExploreCollectionCategoriesCell.self, forCellWithReuseIdentifier: String(describing: ExploreCollectionCategoriesCell.self))
        register(ExploreCollectionRecipeCell.self, forCellWithReuseIdentifier: String(describing: ExploreCollectionRecipeCell.self))
        register(ExploreCollectionSeparatorCell.self, forCellWithReuseIdentifier: String(describing: ExploreCollectionSeparatorCell.self))
        
        dataSource = self
        delegate = self
    }
}
