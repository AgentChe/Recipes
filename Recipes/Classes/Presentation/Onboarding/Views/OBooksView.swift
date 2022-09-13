//
//  OBooksView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class OBooksView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var imagesCollectionView = makeImagesCollectionView()
    lazy var dislikeButton = makeDislikeButton()
    lazy var likeButton = makeLikeButton()
    lazy var preloader = makePreloader()
    
    private lazy var selectedCategoriesIds = PublishRelay<[Int]>()
    private lazy var likedBooks = PublishRelay<[BookCover]>()
    
    private lazy var books = makeBooks()
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
            .logEvent(name: "Onboarding Books Screen")
    }
}

// MARK: OCategoriesViewDelegate
extension OBooksView: OCategoriesViewDelegate {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement]) {
        let ids = elements.map { $0.id }
        selectedCategoriesIds.accept(ids)
    }
}

// MARK: Private
private extension OBooksView {
    func initalize() {
        backgroundColor = Appearance.background
        
        activity
            .drive(Binder(self) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                base.imagesCollectionView.isHidden = activity
                base.dislikeButton.isHidden = activity
                base.likeButton.isHidden = activity
            })
            .disposed(by: disposeBag)
        
        books
            .drive(Binder(self) { base, books in
                base.imagesCollectionView.setup(books: books) { likedBooks in
                    base.likedBooks.accept(likedBooks)
                }
            })
            .disposed(by: disposeBag)
        
        liked
            .drive(Binder(self) { base, void in
                base.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    func makeBooks() -> Driver<[BookCover]> {
        selectedCategoriesIds
            .flatMapLatest { [weak self] ids -> Observable<[BookCover]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[BookCover]> {
                    let zipped = ids.map { id -> Single<[BookCover]> in
                        self.contentManager
                            .obtainCategoryBooksCover(categoryId: id)
                    }
                    return Single
                        .zip(zipped)
                        .map { books -> [BookCover] in
                            books.reduce([]) { $0 + $1 }
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
        likedBooks
            .flatMapLatest { [weak self] books -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    let zipped = books.map { book -> Single<Bool> in
                        self.contentManager
                            .save(book: book)
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
private extension OBooksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 126.scale : 62.scale)
        ])
        
        NSLayoutConstraint.activate([
            imagesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imagesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 74.scale)
        ])
        
        NSLayoutConstraint.activate([
            dislikeButton.widthAnchor.constraint(equalToConstant: 147.scale),
            dislikeButton.heightAnchor.constraint(equalToConstant: 100.scale),
            dislikeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35.scale),
            dislikeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -83.scale : -33.scale)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 147.scale),
            likeButton.heightAnchor.constraint(equalToConstant: 100.scale),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -83.scale : -33.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: imagesCollectionView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OBooksView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Book.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImagesCollectionView() -> OBookImageCollectionView {
        let view = OBookImageCollectionView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDislikeButton() -> OBookButton {
        let view = OBookButton(imageName: "Onboarding.Book.Dislike")
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
    
    func makeLikeButton() -> OBookButton {
        let view = OBookButton(imageName: "Onboarding.Book.Like")
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
