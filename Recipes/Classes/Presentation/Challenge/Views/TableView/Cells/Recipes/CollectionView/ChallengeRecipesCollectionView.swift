//
//  ChallengeRecipesCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeRecipesCollectionView: UICollectionView {
    weak var mainDelegate: ChallengeTableDelegate?
    
    private lazy var elements = [ChallengeRecipeElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChallengeRecipesCollectionView {
    func setup(elements: [ChallengeRecipeElement]) {
        self.elements = elements
        
        CATransaction.setCompletionBlock { [weak self] in
            if let index = elements.firstIndex(where: { $0.current }) {
                self?.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
            }
        }
        
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UICollectionViewDataSource
extension ChallengeRecipesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ChallengeRecipesCollectionCell.self), for: indexPath) as! ChallengeRecipesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ChallengeRecipesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 294.scale, height: 188.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.challengeTableDidTapped(element: element)
    }
}

// MARK: Private
private extension ChallengeRecipesCollectionView {
    func initialize() {
        register(ChallengeRecipesCollectionCell.self, forCellWithReuseIdentifier: String(describing: ChallengeRecipesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
