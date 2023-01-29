//
//  ShoppingView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import UIKit
import RxSwift

final class ShoppingView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var filterView = makeFilterView()
    lazy var emptyView = makeEmptyView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: titleLabelMaxTopConstant)
    private lazy var filterTopConstraint = filterView.topAnchor.constraint(equalTo: topAnchor, constant: filterMaxTopConstant)
    
    private lazy var titleLabelMaxTopConstant = ScreenSize.isIphoneXFamily ? 91.scale : 61.scale
    private lazy var titleLabelMinTopConstant = titleLabelMaxTopConstant / 2
    private lazy var filterMaxTopConstant = ScreenSize.isIphoneXFamily ? 160.scale : 130.scale
    private lazy var filterMinTopConstant = filterMaxTopConstant / 2
    
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
        
        tableView.rx.contentOffset
            .bind(to: Binder(self) { base, offset in
                let bias = max(base.tableView.contentInset.top + offset.y, 0)
                
                let titleLabelConstant = max(base.titleLabelMaxTopConstant - bias, base.titleLabelMinTopConstant)
                base.titleLabelTopConstraint.constant = titleLabelConstant
                base.titleLabel.isHidden = titleLabelConstant == base.titleLabelMinTopConstant
                
                base.filterTopConstraint.constant = max(base.filterMaxTopConstant - bias, base.filterMinTopConstant)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension ShoppingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: filterMinTopConstant + 31.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 31.scale),
            filterTopConstraint
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
        let topInset = filterMaxTopConstant - filterMinTopConstant + 30.scale
        
        let view = ShoppingTableView()
        view.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 30.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: -topInset), animated: false)
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
