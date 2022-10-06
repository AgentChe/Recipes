//
//  ChallengeButtonsCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeButtonsCell: UITableViewCell {
    weak var delegate: ChallengeTableDelegate?
    
    lazy var cookButton = makeCookButton()
    
    private var element: ChallengeButtonsElement?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChallengeButtonsCell {
    func setup(element: ChallengeButtonsElement) {
        self.element = element
    }
}

// MARK: Private
private extension ChallengeButtonsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func cookTapped() {
        guard let recipeId = element?.currentDayRecipeId else {
            return
        }
        
        delegate?.challengeTableDidTappedCook(recipeId: recipeId)
    }
}

// MARK: Make constraints
private extension ChallengeButtonsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            cookButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cookButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            cookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeButtonsCell {
    func makeCookButton() -> ChallengeButton {
        let view = ChallengeButton(icon: "Challenge.CookIcon",
                                   text: "Challenge.Cook".localized)
        view.backgroundColor = Appearance.secondary2
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(cookTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
