//
//  ODietsView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.09.2022.
//

import UIKit

final class ODietsView: OSlideView {
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ODietsView {
    func initialize() {
        
    }
}

// MARK: Make constraints
private extension ODietsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension ODietsView {
    
}
