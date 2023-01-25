//
//  OProgressView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.08.2022.
//

import UIKit
import RxSwift

final class OProgressView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var bottomView = makeBottomView()
    
    private lazy var titleAttrs = makeTitleAttrs()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var animationCompleted = false
    private lazy var requestCompleted = false
    
    private var timer: Timer?
    
    private let combineData: OnboardingCombineData
    
    init(step: OnboardingView.Step, combineData: OnboardingCombineData) {
        self.combineData = combineData
        
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        calculatePercent()
        request()
        
        AmplitudeManager.shared
            .logEvent(name: "Progress Screen")
    }
}

// MARK: Private
private extension OProgressView {
    func initialize() {
        backgroundColor = Appearance.primaryYellow
    }
    
    func request() {
        guard let data = combineData.combineData() else {
            return
        }
        
        func source() -> Single<Void> {
            profileManager
                .set(goal: data.goal,
                     categories: data.categories,
                     diets: data.diets,
                     pace: data.pace,
                     time: data.time,
                     pushToken: data.pushToken,
                     notificationsOptions: data.notificationsOptions)
        }
        
        func error(err: Error) -> Observable<Void> {
            open(error: err)
        }
        
        observableRetrySingle
            .retry(source: { source() },
                   trigger: { error(err: $0) })
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, void in
                base.requestCompleted = true
                base.checkCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    func calculatePercent() {
        let duration = Double(7.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            self.progressView.setup(percent: percent)
            self.updateTitle(percent: percent)
            self.bottomView.setup(percent: percent)
            
            if seconds >= duration {
                timer.invalidate()
                
                self.calculatePercentFinish()
            }
        }
    }
    
    func updateTitle(percent: Int) {
        let string: String
        if percent <= 33 {
            string = "Onboarding.Progress.Title1".localized
        } else if percent <= 66 {
            string = "Onboarding.Progress.Title2".localized
        } else {
            string = "Onboarding.Progress.Title3".localized
        }
        titleLabel.attributedText = string.attributed(with: titleAttrs)
    }
    
    func calculatePercentFinish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.animationCompleted = true
            self?.checkCompleted()
        }
    }
    
    func checkCompleted() {
        guard animationCompleted && requestCompleted else {
            return
        }
        
        onNext()
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension OProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 168.scale : 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 318.scale : 260.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 77.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> OCircleProgressView {
        let view = OCircleProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> OBottomProgressView {
        let view = OBottomProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
    }
}
