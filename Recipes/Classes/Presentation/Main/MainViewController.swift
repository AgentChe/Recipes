//
//  MainViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainViewCoordinator(parentVC: self)
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview
        
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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .forYou)
            })
            .disposed(by: disposeBag)
        
        requestReviewIfNeeded()
        addActionsToTabs()
    }
}

// MARK: Make
extension MainViewController {
    static func make(requestReview: Bool = false) -> MainViewController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
 
// MARK: Private
private extension MainViewController {
    func requestReviewIfNeeded() {
        guard requestReview else {
            return
        }

        RequestReview.request()
    }
    
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.tabView.forYouItem
                    .rx.tap.map { TabView.Tab.forYou },
                
                mainView.tabView.shoppingItem
                    .rx.tap.map { TabView.Tab.shopping },
                
                mainView.tabView.myRecipesItem
                    .rx.tap.map { TabView.Tab.myRecipes },
                
                mainView.tabView.exploreItem
                    .rx.tap.map { TabView.Tab.explore }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
