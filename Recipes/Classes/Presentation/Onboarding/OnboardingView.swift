//
//  OnboardingView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case welcome, info, goal, age, brief, categories, quantity, pace, time, notifications, infoLibrary, books, progress
    }
    
    var didFinish: (() -> Void)?
    
    private lazy var goalView = OGoalView(step: .goal)
    private lazy var categoriesView = OCategoriesView(step: .categories)
    private lazy var quantityView = OQuantityView(step: .quantity)
    private lazy var paceView = OPaceView(step: .pace)
    private lazy var timeView = OTimeView(step: .time)
    private lazy var notificationsView = ONotificationsView(step: .notifications)
    private lazy var booksView = OBooksView(step: .books)
    private lazy var progressView = OProgressView(step: .progress, combineData: combineData)

    private lazy var contentViews: [OSlideView] = {
        [
            OWelcomeView(step: .welcome),
            OInfoView(step: .info),
            goalView,
            OAgeView(step: .age),
            OBriefView(step: .brief),
            categoriesView,
            quantityView,
            paceView,
            timeView,
            notificationsView,
            OInfoLibraryView(step: .infoLibrary),
            booksView,
            progressView
        ]
    }()
    
    private var step = Step.welcome
    
    private lazy var combineData = OnboardingCombineData()
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController) {
        self.vc = vc
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        scroll(to: nextStep)
    }
    
    func slideViewDidBack(from step: OnboardingView.Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        scroll(to: previousStep)
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
                
                view.clipsToBounds = true
                view.delegate = self
                
                if index == 0 {
                    view.frame.origin = CGPoint(x: 0, y: 0)
                    addSubview(view)
                }
            }
        
        goalView.goalDelegate = combineData
        categoriesView.add(observer: combineData)
        categoriesView.add(observer: booksView)
        quantityView.quantityDelegate = combineData
        paceView.paceDelegate = combineData
        timeView.timeDelegate = combineData
        notificationsView.notificationsDelegate = combineData
        booksView.vc = vc
        progressView.vc = vc
    }
    
    func scroll(to newStep: Step) {
        let currentIndex = step.rawValue
        let scrollToIndex = newStep.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = contentViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = contentViews[currentIndex]
        let scrollToView = contentViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 375.scale * CGFloat(direction), y: 0)
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 375.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.step = newStep
        })
    }
}
