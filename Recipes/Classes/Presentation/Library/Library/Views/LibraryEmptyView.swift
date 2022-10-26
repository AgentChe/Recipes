//
//  LibraryEmptyView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit

final class LibraryEmptyView: UIView {
    enum State {
        case saved, history
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LibraryEmptyView {
    func update(at state: State) {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 19.scale))
            .lineHeight(26.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        switch state {
        case .saved:
            imageView.image = UIImage(named: "Library.Empty.Saved")
            titleLabel.attributedText = "Library.Empty.Saved.Title".localized.attributed(with: titleAttrs)
            subTitleLabel.attributedText = "Library.Empty.Saved.SubTitle".localized.attributed(with: subTitleAttrs)
        case .history:
            imageView.image = UIImage(named: "Library.Empty.History")
            titleLabel.attributedText = "Library.Empty.History.Title".localized.attributed(with: titleAttrs)
            subTitleLabel.attributedText = "Library.Empty.History.SubTitle".localized.attributed(with: subTitleAttrs)
        }
    }
}

// MARK: Make constraints
private extension LibraryEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 146.scale),
            imageView.heightAnchor.constraint(equalToConstant: 123.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 166.scale),
            button.heightAnchor.constraint(equalToConstant: 49.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LibraryEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primaryYellow
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("Library.Empty.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
