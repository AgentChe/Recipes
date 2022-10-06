//
//  RankingsCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit

protocol RankingsCollectionDelegate: AnyObject {
    func rankingCollectionDidTapped(element: RankingsCollectionElement)
}

final class RankingsCollectionView: UICollectionView {
    weak var mainDelegate: RankingsCollectionDelegate?
    
    private lazy var elements = [RankingsCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RankingsCollectionView {
    func setup(elements: [RankingsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension RankingsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RankingsCollectionCell.self), for: indexPath) as! RankingsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RankingsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = elements[indexPath.row]
        let width = RankingsCollectionCell.width(for: element)
        return CGSize(width: width, height: 31.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements.forEach { $0.isSelected = false }
        
        let element = elements[indexPath.row]
        element.isSelected = true
        
        reloadData()
        
        mainDelegate?.rankingCollectionDidTapped(element: element)
    }
}

// MARK: Private
private extension RankingsCollectionView {
    func initialize() {
        register(RankingsCollectionCell.self, forCellWithReuseIdentifier: String(describing: RankingsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
