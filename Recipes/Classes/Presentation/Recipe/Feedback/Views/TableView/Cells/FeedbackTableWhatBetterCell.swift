//
//  FeedbackTableBetterCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class FeedbackTableBetterCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var textView = makeTextView()
    
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
extension FeedbackTableBetterCell {
    func setup(element: String?, editing: @escaping ((String?) -> Void)) {
        textView.setup(text: element)
        textView.editing = { [weak self] in
            editing(self?.textView.textView.text)
        }
    }
}

// MARK: Private
private extension FeedbackTableBetterCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension FeedbackTableBetterCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 188.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackTableBetterCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.WhatCanBetter".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextView() -> FeedbackTextView {
        let view = FeedbackTextView(placeholder: "Feedback.WhatCanBetter.Placeholder".localized)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
