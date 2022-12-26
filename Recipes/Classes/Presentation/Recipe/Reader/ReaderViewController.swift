//
//  ReaderViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit
import RxSwift

final class ReaderViewController: UIViewController {
    lazy var mainView = ReaderView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: ReaderViewModel
    
    private init(recipe: Recipe, step: RecipeStep) {
        viewModel = ReaderViewModel(recipe: recipe, startStep: step)
        
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
            .logEvent(name: "Recipe Step Screen")
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                AmplitudeManager.shared
                    .logEvent(name: "Recipe Step Tap", parameters: ["what": "close"])
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.stepsButton.rx.tap
            .withLatestFrom(viewModel.recipe)
            .withLatestFrom(viewModel.currentStep) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                AmplitudeManager.shared
                    .logEvent(name: "Recipe Step Tap", parameters: ["what": "steps"])
                
                base.open(steps: args.0.steps, currentStep: args.1)
            })
            .disposed(by: disposeBag)
        
        mainView.markFinishButton.rx.tap
            .bind(to: Binder(self) { base, void in
                AmplitudeManager.shared
                    .logEvent(name: "Recipe Step Tap", parameters: ["what": "mark as finished"])
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                AmplitudeManager.shared
                    .logEvent(name: "Recipe Step Tap", parameters: ["what": "share"])
                
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.progress
            .drive(Binder(mainView.progressView) { base, progress in
                base.setProgress(progress, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLastStep
            .drive(Binder(mainView) { base, isLastStep in
                base.bottomView(hidden: !isLastStep)
            })
            .disposed(by: disposeBag)
        
        addSwipeActions()
    }
}

// MARK: Make
extension ReaderViewController {
    static func make(recipe: Recipe, step: RecipeStep) -> ReaderViewController {
        let vc = ReaderViewController(recipe: recipe, step: step)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ReaderViewController {
    func addSwipeActions() {
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        
        leftSwipe.rx.event
            .withLatestFrom(viewModel.currentStep)
            .bind(to: viewModel.didSwipeToNextStep)
            .disposed(by: disposeBag)
        
        rightSwipe.rx.event
            .withLatestFrom(viewModel.currentStep)
            .bind(to: viewModel.didSwipeToPreviousStep)
            .disposed(by: disposeBag)
        
        mainView.tableView.addGestureRecognizer(leftSwipe)
        mainView.tableView.addGestureRecognizer(rightSwipe)
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    func open(steps: [RecipeStep], currentStep: RecipeStep) {
        let vc = StepsViewController.make(steps: steps, selectedStep: currentStep) { [weak self] step in
            self?.viewModel.didSelectStep.accept(step)
        }
        present(vc, animated: true)
    }
}
