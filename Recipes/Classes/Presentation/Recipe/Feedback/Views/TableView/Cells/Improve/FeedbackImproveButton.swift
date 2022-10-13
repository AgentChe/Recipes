//
//  FeedbackImproveButton.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class FeedbackImproveButton: UIButton {
    var number: Int = 0
    
    var title: String? {
        didSet {
            update()
        }
    }
    
    var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FeedbackImproveButton {
    func update() {
        let attrs = TextAttributes()
            .textColor(marked ? Appearance.white : Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        setAttributedTitle(title?.attributed(with: attrs), for: .normal)
        
        backgroundColor = marked ? Appearance.primaryYellow : Appearance.secondary5
    }
}
