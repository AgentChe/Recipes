//
//  ForYouViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class ForYouViewController: UIViewController {
    lazy var mainView = ForYouView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ForYouViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "For You Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.headerView.settingsButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = SettingsViewController.make()
                base.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: Make
extension ForYouViewController {
    static func make() -> ForYouViewController {
        let vc = ForYouViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ForYouTableDelegate
extension ForYouViewController: ForYouTableDelegate {
    func forYouTableDidTapped(recipe: RecipeCover) {
        let vc: UIViewController

        let needPayment = !SessionManager().hasActiveSubscriptions()
        if needPayment && recipe.paid {
            vc = PaygateViewController.make()
        } else {
            vc = RecipeViewController.make(recipeId: recipe.id)
        }

        present(vc, animated: true)
    }
    
    func forYouTableDidTapped(ranking: Ranking) {
        let vc = RankingsViewController.make(start: ranking)
        present(vc, animated: true)
    }
    
    func forYouTableDidTapped(category: Category) {
        let vc = CategoryViewController.make(category: category)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension ForYouViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
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
