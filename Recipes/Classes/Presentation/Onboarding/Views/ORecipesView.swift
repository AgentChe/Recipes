//
//  ORecipesView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class ORecipesView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var imagesCollectionView = makeImagesCollectionView()
    lazy var nameLabel = makeLabel()
    lazy var timeIconView = makeTimeIconView()
    lazy var timeLabel = makeLabel()
    lazy var dislikeButton = makeDislikeButton()
    lazy var likeButton = makeLikeButton()
    lazy var preloader = makePreloader()
    
    private lazy var selectedCategoriesIds = PublishRelay<[Int]>()
    private lazy var likedRecipes = PublishRelay<[RecipeCover]>()
    
    private lazy var recipes = makeRecipes()
    private lazy var liked = makeLiked()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initalize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Onboarding Recipes Screen")
    }
}

// MARK: OCategoriesViewDelegate
extension ORecipesView: OCategoriesViewDelegate {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement]) {
        let ids = elements.map { $0.id }
        selectedCategoriesIds.accept(ids)
    }
}

// MARK: ORecipeImageCollectionViewDelegate
extension ORecipesView: ORecipeImageCollectionViewDelegate {
    func recipeImageCollectionDidChange(frontRecipe: RecipeCover) {
        let nameAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        nameLabel.attributedText = frontRecipe.name.attributed(with: nameAttrs)
        
        let timeAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        let time = String(format: "Onboarding.Recipe.min".localized, frontRecipe.time)
        timeLabel.attributedText = time.attributed(with: timeAttrs)
    }
}

// MARK: Private
private extension ORecipesView {
    func initalize() {
        backgroundColor = Appearance.background
        
        activity
            .drive(Binder(self) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                
                let hiddenViews = [
                    base.imagesCollectionView,
                    base.dislikeButton,
                    base.likeButton,
                    base.nameLabel,
                    base.timeIconView,
                    base.timeLabel
                ]
                hiddenViews.forEach { $0.isHidden = activity }
            })
            .disposed(by: disposeBag)
        
        recipes
            .drive(Binder(self) { base, recipes in
                base.imagesCollectionView.setup(recipes: recipes) { likedRecipes in
                    base.likedRecipes.accept(likedRecipes)
                }
            })
            .disposed(by: disposeBag)
        
        liked
            .drive(Binder(self) { base, void in
                base.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    func makeRecipes() -> Driver<[RecipeCover]> {
        selectedCategoriesIds
            .flatMapLatest { [weak self] ids -> Observable<[RecipeCover]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[RecipeCover]> {
                    let zipped = ids.map { id -> Single<[RecipeCover]> in
                        self.contentManager
                            .obtainCategoryRecipesCover(categoryId: id)
                    }
                    return Single
                        .zip(zipped)
                        .map { recipes -> [RecipeCover] in
                            recipes.reduce([]) { $0 + $1 }
                        }
                }
                
                func error(err: Error) -> Observable<Void> {
                    self.openError()
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { error(err: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeLiked() -> Driver<Void> {
        likedRecipes
            .flatMapLatest { [weak self] recipes -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    let zipped = recipes.map { recipe -> Single<Bool> in
                        self.contentManager
                            .save(recipe: recipe)
                    }
                    return Single
                        .zip(zipped)
                        .flatMap { results -> Single<Void> in
                            if results.contains(false) {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(Void())
                        }
                }
                
                func error(err: Error) -> Observable<Void> {
                    self.openError()
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { error(err: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    @objc
    func likeTapped() {
        imagesCollectionView.like()
    }
    
    @objc
    func dislikeTapped() {
        imagesCollectionView.dislike()
    }
}

// MARK: Make constraints
private extension ORecipesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 126.scale : 42.scale)
        ])
        
        NSLayoutConstraint.activate([
            imagesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imagesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 74.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45.scale),
            nameLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 152.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor, constant: 3.scale),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            dislikeButton.widthAnchor.constraint(equalToConstant: 147.scale),
            dislikeButton.heightAnchor.constraint(equalToConstant: 100.scale),
            dislikeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35.scale),
            dislikeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -83.scale : -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 147.scale),
            likeButton.heightAnchor.constraint(equalToConstant: 100.scale),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -83.scale : -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: imagesCollectionView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ORecipesView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Recipe.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImagesCollectionView() -> ORecipeImageCollectionView {
        let view = ORecipeImageCollectionView()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Recipe.Time")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDislikeButton() -> ORecipeButton {
        let view = ORecipeButton(imageName: "Onboarding.Recipe.Dislike")
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeLikeButton() -> ORecipeButton {
        let view = ORecipeButton(imageName: "Onboarding.Recipe.Like")
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
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
