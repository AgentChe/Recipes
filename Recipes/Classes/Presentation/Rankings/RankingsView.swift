//
//  RankingsView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class RankingsView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var rankingView = makeRankingView()
    lazy var recipesView = makeRecipesView()
    lazy var preloader = makePreloader()
    
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
private extension RankingsView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension RankingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rankingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rankingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rankingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35.scale),
            rankingView.heightAnchor.constraint(equalToConstant: 31.scale)
        ])
        
        NSLayoutConstraint.activate([
            recipesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipesView.topAnchor.constraint(equalTo: rankingView.bottomAnchor, constant: 2.scale),
            recipesView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: recipesView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: recipesView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RankingsView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Ranking.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Ranking.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRankingView() -> RankingsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20.scale
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16.scale, bottom: 0, right: 16.scale)
        
        let view = RankingsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRecipesView() -> RRecipesTableView {
        let view = RRecipesTableView()
        view.contentInset = UIEdgeInsets(top: 30.scale, left: 0, bottom: 30.scale, right: 0)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
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
