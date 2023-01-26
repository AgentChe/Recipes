//
//  ReaderView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit

final class ReaderView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var stepsButton = makeStepsButton()
    lazy var collectionView = makeCollectionView()
    lazy var bottomView = makeBottomView()
    lazy var shareButton = makeShareButton()
    lazy var markFinishButton = makeMarkFinishButton()
    lazy var progressView = makeProgressView()
    
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
private extension ReaderView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension ReaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            stepsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            stepsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            stepsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 326.scale),
            stepsButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 75.scale),
            collectionView.bottomAnchor.constraint(equalTo: progressView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: progressView.topAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 123.scale : 93.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 54.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 54.scale),
            shareButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 25.scale),
            shareButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            markFinishButton.widthAnchor.constraint(equalToConstant: 166.scale),
            markFinishButton.heightAnchor.constraint(equalToConstant: 49.scale),
            markFinishButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 184.scale),
            markFinishButton.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReaderView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Reader.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Reader.Steps"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ReaderCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        let view = ReaderCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> RecipeNavButton {
        let view = RecipeNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Reader.Share")
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makeMarkFinishButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primaryYellow
        view.setAttributedTitle("Reader.MarkAsFinished".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = Appearance.secondary5
        view.progressTintColor = Appearance.primaryYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
