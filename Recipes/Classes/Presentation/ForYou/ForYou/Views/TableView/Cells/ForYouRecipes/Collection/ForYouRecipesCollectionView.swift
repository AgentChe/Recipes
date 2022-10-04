//
//  ForYouRecipesCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class ForYouRecipesCollectionView: UICollectionView {
    private lazy var elements = [RecipeCover]()
    private var tapped: ((RecipeCover) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouRecipesCollectionView {
    func setup(elements: [RecipeCover], tapped: @escaping ((RecipeCover) -> Void)) {
        self.elements = elements
        self.tapped = tapped
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ForYouRecipesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ForYouRecipesCollectionCell.self), for: indexPath) as! ForYouRecipesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ForYouRecipesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164.scale, height: 221.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        tapped?(element)
    }
}

// MARK: Private
private extension ForYouRecipesCollectionView {
    func initialize() {
        register(ForYouRecipesCollectionCell.self, forCellWithReuseIdentifier: String(describing: ForYouRecipesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
