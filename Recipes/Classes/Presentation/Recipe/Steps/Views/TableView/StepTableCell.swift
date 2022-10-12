//
//  StepTableCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit

final class StepTableCell: UITableViewCell {
    lazy var numberLabel = makeLabel()
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
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
extension StepTableCell {
    func setup(element: StepTableElement) {
        contentView.backgroundColor = element.isSelected ? Appearance.secondary5 : UIColor.clear
        
        let numberAttrs = TextAttributes()
            .textColor(Appearance.primaryYellow)
            .font(Fonts.PlusJakartaSans.bold(size: 40.scale))
            .lineHeight(48.scale)
            .letterSpacing(0.37.scale)
        numberLabel.attributedText = element.number.attributed(with: numberAttrs)
        
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .lineBreakMode(.byTruncatingTail)
        label.attributedText = element.step.shortDescription.attributed(with: attrs)
        
        separator.isHidden = element.separatorHidden
    }
}

// MARK: Private
private extension StepTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StepTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 37.scale),
            numberLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 86.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StepTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
