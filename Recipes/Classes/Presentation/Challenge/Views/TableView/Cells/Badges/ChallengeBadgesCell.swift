//
//  ChallengeBadgesCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeBadgesCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var goodStartView = makeBadgeView()
    lazy var completeDay3View = makeBadgeView()
    lazy var completeChallengeView = makeBadgeView()
    
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
extension ChallengeBadgesCell {
    func setup(element: ChallengeBadgesElement) {
        goodStartView.setup(image: "Challenge.Badges.GoodStart",
                            name: "Challenge.Badges.GoodStart".localized,
                            progress: element.goodStartProgress,
                            hiddenTextProgress: element.goodStartProgress == 100)
        completeDay3View.setup(image: "Challenge.Badges.CompleteDay3",
                               name: "Challenge.Badges.CompleteDay3".localized,
                               progress: element.completeDay3Progress,
                               hiddenTextProgress: !(element.goodStartProgress == 100 && element.completeDay3Progress < 100))
        completeChallengeView.setup(image: "Challenge.Badges.Complete",
                                    name:   "Challenge.Badges.CompleteChallenge".localized,
                                    progress: element.completeChallengeProgress,
                                    hiddenTextProgress: !(element.completeDay3Progress == 100 && element.completeChallengeProgress < 100))
    }
}

// MARK: Private
private extension ChallengeBadgesCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ChallengeBadgesCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            goodStartView.widthAnchor.constraint(equalToConstant: 105.scale),
            goodStartView.heightAnchor.constraint(equalToConstant: 138.scale),
            goodStartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            goodStartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            completeDay3View.widthAnchor.constraint(equalToConstant: 105.scale),
            completeDay3View.heightAnchor.constraint(equalToConstant: 138.scale),
            completeDay3View.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 133.scale),
            completeDay3View.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            completeChallengeView.widthAnchor.constraint(equalToConstant: 105.scale),
            completeChallengeView.heightAnchor.constraint(equalToConstant: 138.scale),
            completeChallengeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 250.scale),
            completeChallengeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeBadgesCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let view = UILabel()
        view.attributedText = "Challenge.Badges".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeBadgeView() -> ChallengeBadgeView {
        let view = ChallengeBadgeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
