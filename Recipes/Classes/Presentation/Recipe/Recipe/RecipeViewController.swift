//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit
import RxSwift
import Kingfisher

final class RecipeViewController: UIViewController {
    lazy var mainView = RecipeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = RecipeViewModel(recipeId: recipeId)
    
    private let recipeId: Int
    
    private init(recipeId: Int) {
        self.recipeId = recipeId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Recipe Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.imageUrl
            .drive(Binder(mainView.imageView) { base, url in
                base.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        mainView.stepButton.rx.tap
            .bind(to: viewModel.didTapRead)
            .disposed(by: disposeBag)
        
        viewModel.reader
            .drive(Binder(self) { base, reader in
                // TODO: impl
//                let vc = ReaderViewController.make(book: reader.0, chapter: reader.1)
//                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedRecipe)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedRecipe
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension RecipeViewController {
    static func make(recipeId: Int) -> RecipeViewController {
        let vc = RecipeViewController(recipeId: recipeId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: RecipeTableDelegate
extension RecipeViewController: RecipeTableDelegate {
    func recipeTableDidTappedShopping() {
        // TODO: реализовать сохранение
    }
    
    func recipeTableDidTapped(step: RecipeStep) {
        viewModel.didTapStep.accept(step)
    }
    
    func recipeTableDidTappedSeeAll() {
        viewModel.didTapSeeAll.accept(Void())
    }
    
    func recipeTableDidTapped(recipe: RecipeCover) {
        let vc: UIViewController
        
        let needPayment = !SessionManager().hasActiveSubscriptions()
        if needPayment && recipe.paid {
            vc = PaygateViewController.make()
        } else {
            vc = RecipeViewController.make(recipeId: recipe.id)
        }
        
        present(vc, animated: true)
    }
    
    func recipeTableDidTapped(category: Category) {
        let vc = CategoryViewController.make(category: category)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension RecipeViewController {
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Recipe.Mark.Check" : "Recipe.Mark.Uncheck")
        mainView.favoriteButton.setImage(image, for: .normal)
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
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        mainView.imageView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
}
