//
//  ShoppingView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import UIKit

final class ShoppingView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var filterView = makeFilterView()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ShoppingView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension ShoppingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 91.scale : 61.scale)
        ])
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 31.scale),
            filterView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 290.scale),
            emptyView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 108.scale : 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ShoppingView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.extraBold(size: 34.scale))
            .lineHeight(40.8.scale)
            .letterSpacing(-1.scale)
        
        let view = UILabel()
        view.attributedText = "Shopping.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFilterView() -> ShoppingFilterView {
        let view = ShoppingFilterView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ShoppingTableView {
        let view = ShoppingTableView()
        view.contentInset = UIEdgeInsets(top: 30.scale, left: 0, bottom: 30.scale, right: 0)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> ShoppingEmptyView {
        let view = ShoppingEmptyView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
