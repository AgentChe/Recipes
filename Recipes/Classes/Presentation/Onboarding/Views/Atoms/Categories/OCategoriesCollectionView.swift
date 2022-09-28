//
//  OCategoriesCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OCategoriesCollectionView: UICollectionView {
    var changeSelection: (() -> Void)?
    
    lazy var elements = [OCategoriesCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OCategoriesCollectionView {
    func setup(elements: [OCategoriesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension OCategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: OCategoriesCollectionCell.self), for: indexPath) as! OCategoriesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension OCategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = OCategoriesCollectionCell.width(for: elements[indexPath.row])
        return CGSize(width: width, height: 40.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].selected.toggle()
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
         }
        
        changeSelection?()
    }
}

// MARK: Private
private extension OCategoriesCollectionView {
    func initialize() {
        register(OCategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: OCategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
