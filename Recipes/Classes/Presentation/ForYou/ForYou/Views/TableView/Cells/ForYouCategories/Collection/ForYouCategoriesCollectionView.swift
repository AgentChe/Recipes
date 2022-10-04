//
//  ForYouCategoriesCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class ForYouCategoriesCollectionView: UICollectionView {
    private lazy var elements = [Category]()
    private var tapped: ((Category) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouCategoriesCollectionView {
    func setup(elements: [Category], tapped: @escaping ((Category) -> Void)) {
        self.elements = elements
        self.tapped = tapped
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ForYouCategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ForYouCategoriesCollectionCell.self), for: indexPath) as! ForYouCategoriesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ForYouCategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = elements[indexPath.row]
        let width = ForYouCategoriesCollectionCell.width(for: element)
        return CGSize(width: width, height: 56.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        tapped?(element)
    }
}

// MARK: Private
private extension ForYouCategoriesCollectionView {
    func initialize() {
        register(ForYouCategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: ForYouCategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
