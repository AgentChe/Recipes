//
//  FeedbackTableImproveCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class FeedbackTableImproveCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var improvesView = makeImprovesView()
    
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
extension FeedbackTableImproveCell {
    func setup(element: [Int], improvesChanged: @escaping ([Int]) -> Void) {
        improvesView.setup(numbers: element)
        improvesView.changeSelection = improvesChanged
    }
}

// MARK: Private
private extension FeedbackTableImproveCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension FeedbackTableImproveCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            improvesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            improvesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            improvesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            improvesView.heightAnchor.constraint(equalToConstant: 354.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackTableImproveCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.Improve.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImprovesView() -> FeedbackImprovesView {
        let view = FeedbackImprovesView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
