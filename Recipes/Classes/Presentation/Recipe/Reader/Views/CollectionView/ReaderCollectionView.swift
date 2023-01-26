//
//  ReaderCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.01.2023.
//

import UIKit

protocol ReaderCollectionDelegate: AnyObject {
    func readerCollectionDidChanged(step: RecipeStep)
}

final class ReaderCollectionView: UICollectionView {
    weak var mainDelegate: ReaderCollectionDelegate?
    
    private lazy var elements = [ReaderCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReaderCollectionView {
    func setup(elements: [ReaderCollectionElement], scrollTo: RecipeStep) {
        self.elements = elements
        
        CATransaction.setCompletionBlock { [weak self] in
            self?.scroll(to: scrollTo)
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
    
    func scroll(to step: RecipeStep) {
        guard let index = elements.firstIndex(where: { $0.step == step }) else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK: UICollectionViewDataSource
extension ReaderCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ReaderCollectionCell.self), for: indexPath) as! ReaderCollectionCell
        cell.setup(elements: elements[indexPath.row].elements)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ReaderCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard
            let cell = visibleCells.first,
            let index = indexPath(for: cell)?.row
        else {
            return
        }
        
        mainDelegate?.readerCollectionDidChanged(step: elements[index].step)
    }
}

// MARK: Private
private extension ReaderCollectionView {
    func initialize() {
        register(ReaderCollectionCell.self, forCellWithReuseIdentifier: String(describing: ReaderCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
