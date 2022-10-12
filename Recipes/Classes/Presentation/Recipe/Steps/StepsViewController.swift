//
//  StepsViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit
import RxSwift

final class StepsViewController: UIViewController {
    lazy var mainView = StepsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: StepsViewModel
    private let selected: ((RecipeStep) -> Void)
    
    private init(steps: [RecipeStep], selectedStep: RecipeStep, selected: @escaping ((RecipeStep) -> Void)) {
        viewModel = StepsViewModel(steps: steps, selectedStep: selectedStep)
        self.selected = selected
        
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
            .logEvent(name: "Steps Screen")
        
        mainView.backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
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
extension StepsViewController {
    static func make(steps: [RecipeStep], selectedStep: RecipeStep, selected: @escaping ((RecipeStep) -> Void)) -> StepsViewController {
        let vc = StepsViewController(steps: steps, selectedStep: selectedStep, selected: selected)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: StepsTableDelegate
extension StepsViewController: StepsTableDelegate {
    func stepsTableDidTapped(step: RecipeStep) {
        dismiss(animated: true) { [weak self] in
            self?.selected(step)
        }
    }
}
