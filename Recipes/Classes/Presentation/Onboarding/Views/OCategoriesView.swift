//
//  OCategoriesView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit
import RxSwift

protocol OCategoriesViewDelegate: AnyObject {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement])
}

final class OCategoriesView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var collectionView = makeCollectionView()
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    private var categoriesDelegates = [Weak<OCategoriesViewDelegate>]()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Onboarding Categories Screen")
    }
}

// MARK: Public
extension OCategoriesView {
    func add(observer: OCategoriesViewDelegate) {
        let weakly = observer as AnyObject
        categoriesDelegates.append(Weak<OCategoriesViewDelegate>(weakly))
        categoriesDelegates = categoriesDelegates.filter { $0.weak != nil }
    }
    
    func remove(observer: OCategoriesViewDelegate) {
        if let index = categoriesDelegates.firstIndex(where: { $0.weak === observer }) {
            categoriesDelegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension OCategoriesView {
    func initialize() {
        backgroundColor = Appearance.background
        
        collectionView.changeSelection = { [weak self] in
            self?.checkEnabled()
        }
        
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(collectionView) { base, categories in
                let elements = categories.map { category -> OCategoriesCollectionElement in
                    OCategoriesCollectionElement(title: category.name, id: category.id)
                }
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func nextTapped() {
        let selected = collectionView.elements.filter { $0.selected }
        categoriesDelegates.forEach { $0.weak?.categoriesViewDidSelected(elements: selected) }
        
        onNext()
    }
    
    func checkEnabled() {
        let marked = collectionView.elements.contains(where: { $0.selected })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 131.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 54.scale),
            backButton.heightAnchor.constraint(equalToConstant: 54.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 54.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OCategoriesView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Categories.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> OCategoriesCollectionView {
        let layout = OCategoriesCollectionLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.sectionInset = UIEdgeInsets(top: 24.scale, left: 24.scale, bottom: 24.scale, right: 24.scale)
        
        let view = OCategoriesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
