//
//  FeedbackViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit
import RxSwift

final class FeedbackViewController: UIViewController {
    lazy var mainView = FeedbackView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: FeedbackViewModel
    
    private init(recipe: Recipe) {
        viewModel = FeedbackViewModel(recipe: recipe)
        
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
            .logEvent(name: "Review Screen")
        
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
        
        mainView.submitButton.rx.tap
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        viewModel.sended
            .drive(Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.submitHidden
            .drive(Binder(mainView.submitButton) { base, hidden in
                base.isHidden = hidden
            })
            .disposed(by: disposeBag)
        
        mainView.rx.keyboardHeight
            .bind(to: Binder(mainView.tableView) { base, keyboardHeight in
                base.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight > 0 ? keyboardHeight : 60.scale, right: 0)
            })
            .disposed(by: disposeBag)
        
        addHideKeyboardAction()
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension FeedbackViewController {
    static func make(recipe: Recipe) -> FeedbackViewController {
        let vc = FeedbackViewController(recipe: recipe)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: FeedbackTableDelegate
extension FeedbackViewController: FeedbackTableDelegate {
    func feedbackTableDidSelectedRating() {
        viewModel.didSelectRating.accept(Void())
    }
}

// MARK: Private
private extension FeedbackViewController {
    func addHideKeyboardAction() {
        let tapGesture = UITapGestureRecognizer()
        mainView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                base.mainView.endEditing(true)
            })
            .disposed(by: disposeBag)
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
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
