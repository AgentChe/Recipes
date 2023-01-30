//
//  ExploreView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import RxSwift

final class ExploreView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var searchView = makeSearchView()
    lazy var collectionView = makeCollectionView()
    lazy var preloader = makePreloader()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: titleLabelMaxTopConstant)
    private lazy var searchViewTopConstraint = searchView.topAnchor.constraint(equalTo: topAnchor, constant: searchMaxTopConstant)
    
    private lazy var titleLabelMaxTopConstant = ScreenSize.isIphoneXFamily ? 91.scale : 61.scale
    private lazy var titleLabelMinTopConstant = titleLabelMaxTopConstant / 2
    private lazy var searchMaxTopConstant = ScreenSize.isIphoneXFamily ? 160.scale : 130.scale
    private lazy var searchMinTopConstant = searchMaxTopConstant / 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreView {
    func initialize() {
        backgroundColor = Appearance.background
        
        collectionView.rx.contentOffset
            .bind(to: Binder(self) { base, offset in
                let bias = max(base.collectionView.contentInset.top + offset.y, 0)
                
                let titleLabelConstant = max(base.titleLabelMaxTopConstant - bias, base.titleLabelMinTopConstant)
                base.titleLabelTopConstraint.constant = titleLabelConstant
                base.titleLabel.isHidden = titleLabelConstant == base.titleLabelMinTopConstant
                
                base.searchViewTopConstraint.constant = max(base.searchMaxTopConstant - bias, base.searchMinTopConstant)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension ExploreView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: searchMinTopConstant + 44.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchViewTopConstraint,
            searchView.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.extraBold(size: 34.scale))
            .lineHeight(40.8.scale)
            .letterSpacing(-1.scale)
        
        let view = UILabel()
        view.attributedText = "Explore.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchView() -> SearchView {
        let view = SearchView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ExploreCollectionView {
        let topInset = searchMaxTopConstant - searchMinTopConstant + 30.scale
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16.scale
        layout.sectionInset = UIEdgeInsets.zero
        
        let view = ExploreCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(top: topInset, left: 16.scale, bottom: 30.scale, right: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -topInset), animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
