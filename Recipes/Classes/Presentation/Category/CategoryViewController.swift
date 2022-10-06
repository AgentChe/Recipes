//
//  CategoryViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit
import RxSwift

final class CategoryViewController: UIViewController {
    lazy var mainView = CategoryView(category: category)
    
    private lazy var viewModel = CategoryViewModel(categoryId: category.id)
    
    private lazy var disposeBag = DisposeBag()
    
    private let category: Category
    
    private init(category: Category) {
        self.category = category
        
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
            .logEvent(name: "Category Screen")
        
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
        
        viewModel.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.mainDelegate = self
    }
}

// MARK: Make
extension CategoryViewController {
    static func make(category: Category) -> CategoryViewController {
        let vc = CategoryViewController(category: category)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: CategoryCollectionDelegate
// TODO: Impl
extension CategoryViewController: CategoryCollectionDelegate {
    func categoryCollectionTapped(recipe: RecipeCover) {
//        let vc: UIViewController
//
//        let needPayment = !SessionManager().hasActiveSubscriptions()
//        if needPayment && recipe.paid {
//            vc = PaygateViewController.make()
//        } else {
//            vc = RecipeViewController.make(recipeId: recipe.id)
//        }
//
//        present(vc, animated: true)
    }
}

// MARK: Private
private extension CategoryViewController {
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
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
