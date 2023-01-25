//
//  OBottomProgressView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.08.2022.
//

import UIKit

final class OBottomProgressView: UIView {
    lazy var profileLabel = makeLabel()
    lazy var recipePreferencesLabel = makeLabel()
    lazy var planLabel = makeLabel()
    
    private lazy var normatAttrs = makeNormalAttrs()
    private lazy var dimAttrs = makeDimAttrs()
    
    private lazy var profileBottomConstraint = NSLayoutConstraint()
    private lazy var recipePreferencesBottomConstraint = NSLayoutConstraint()
    private lazy var planBottomConstraint = NSLayoutConstraint()
    
    private var currentStage: Stage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OBottomProgressView {
    func setup(percent: Int) {
        let stage = stage(percent: percent)
        
        if stage != currentStage {
            hiddenLabelIfNeeded(stage: stage)
            putAwayLabel()
            upCurrentLabel(at: stage, totalPercent: percent)
        }
        
        updateProgress(stage: stage, totalPercent: percent)
        
        currentStage = stage
    }
}

// MARK: Private
private extension OBottomProgressView {
    enum Stage {
        case profile, recipePreferences, plan
    }
    
    func updateProgress(stage: Stage, totalPercent: Int) {
        let label = stageLabel(at: stage)
        let percent = stagePercent(stage: stage, totalPercent: totalPercent)
        let title = stageTitle(at: stage, percent: percent)
        label.attributedText = title.attributed(with: normatAttrs)
    }
    
    func hiddenLabelIfNeeded(stage: Stage) {
        switch stage {
        case .profile, .recipePreferences:
            break
        case .plan:
            profileLabel.alpha = 0
        }
    }
    
    func putAwayLabel() {
        guard let currentStage = currentStage else {
            return
        }
        
        let label = stageLabel(at: currentStage)
        let constraint = stageConstraint(at: currentStage)
        
        let title = label.text?.attributed(with: dimAttrs)
        label.attributedText = title
        
        constraint.isActive = false
        constraint.constant = -40.scale
        constraint.isActive = true
        
        layoutIfNeeded()
    }
    
    func upCurrentLabel(at stage: Stage, totalPercent: Int) {
        let label = stageLabel(at: stage)
        let constraint = stageConstraint(at: stage)
        
        constraint.isActive = false
        constraint.constant = -2.scale
        constraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            label.alpha = 1
            self?.layoutIfNeeded()
        })
    }
    
    func stagePercent(stage: Stage, totalPercent: Int) -> Int {
        let stageTotalProgress: Int
        let stageCurrentProgress: Int
        
        switch stage {
        case .profile:
            stageTotalProgress = 33
            stageCurrentProgress = totalPercent
        case .recipePreferences:
            stageTotalProgress = 63
            stageCurrentProgress = totalPercent - 33
        case .plan:
            stageTotalProgress = 34
            stageCurrentProgress = totalPercent - 66
        }
        
        let percent = 100 / (CGFloat(stageTotalProgress) / CGFloat(stageCurrentProgress))
        return Int(percent)
    }
    
    func stageLabel(at stage: Stage) -> UILabel {
        switch stage {
        case .profile:
            return profileLabel
        case .recipePreferences:
            return recipePreferencesLabel
        case .plan:
            return planLabel
        }
    }
    
    func stageConstraint(at stage: Stage) -> NSLayoutConstraint {
        switch stage {
        case .profile:
            return profileBottomConstraint
        case .recipePreferences:
            return recipePreferencesBottomConstraint
        case .plan:
            return planBottomConstraint
        }
    }
    
    func stageTitle(at stage: Stage, percent: Int) -> String {
        switch stage {
        case .profile:
            return String(format: "Onboarding.Progress.Bottom1".localized, percent)
        case .recipePreferences:
            return String(format: "Onboarding.Progress.Bottom2".localized, percent)
        case .plan:
            return String(format: "Onboarding.Progress.Bottom3".localized, percent)
        }
    }
    
    func stage(percent: Int) -> Stage {
        if percent <= 33 {
            return .profile
        } else if percent <= 66 {
            return .recipePreferences
        } else {
            return .plan
        }
    }
}

// MARK: Make constraints
private extension OBottomProgressView {
    func makeConstraints() {
        profileBottomConstraint = profileLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            profileLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileBottomConstraint
        ])
        
        recipePreferencesBottomConstraint = recipePreferencesLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            recipePreferencesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            recipePreferencesBottomConstraint
        ])
        
        planBottomConstraint = planLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            planLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            planBottomConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension OBottomProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNormalAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
    }
    
    func makeDimAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.semiBold(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
    }
}
