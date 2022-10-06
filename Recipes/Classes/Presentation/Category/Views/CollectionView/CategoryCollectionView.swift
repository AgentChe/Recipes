//
//  CategoryCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

protocol CategoryCollectionDelegate: AnyObject {
    func categoryCollectionTapped(recipe: RecipeCover)
}

final class CategoryCollectionView: UICollectionView {
    weak var mainDelegate: CategoryCollectionDelegate?
    
    private lazy var elements = [RecipeCover]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CategoryCollectionView {
    func setup(elements: [RecipeCover]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionCell.self), for: indexPath) as! CategoryCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CategoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 163.scale, height: 221.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.categoryCollectionTapped(recipe: element)
    }
}

// MARK: Private
private extension CategoryCollectionView {
    func initialize() {
        register(CategoryCollectionCell.self, forCellWithReuseIdentifier: String(describing: CategoryCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
