//
//  RatingView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit
import RxSwift

final class RatingView: UIView {
    var tapped: ((Int) -> Void)?
    
    lazy var rating1View = makeButton()
    lazy var rating2View = makeButton()
    lazy var rating3View = makeButton()
    lazy var rating4View = makeButton()
    lazy var rating5View = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RatingView {
    func setup(rating: Int) {
        update(rating: rating)
    }
}

// MARK: Private
private extension RatingView {
    func initialize() {
        Observable
            .merge(
                rating1View.rx.tap.map { 1 },
                rating2View.rx.tap.map { 2 },
                rating3View.rx.tap.map { 3 },
                rating4View.rx.tap.map { 4 },
                rating5View.rx.tap.map { 5 }
            )
            .bind(to: Binder(self) { base, rate in
                base.tapped?(rate)
                base.update(rating: rate)
            })
            .disposed(by: disposeBag)
    }
    
    func update(rating: Int) {
        let views = [
            rating1View,
            rating2View,
            rating3View,
            rating4View,
            rating5View
        ]
        
        views.forEach { $0.setImage(UIImage(named: "Feedback.Star.Empty"), for: .normal) }
        views.prefix(rating).forEach { $0.setImage(UIImage(named: "Feedback.Star.Filled"), for: .normal) }
    }
}

// MARK: Make constraints
private extension RatingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            rating1View.widthAnchor.constraint(equalToConstant: 50.scale),
            rating1View.heightAnchor.constraint(equalToConstant: 50.scale),
            rating1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            rating1View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rating2View.widthAnchor.constraint(equalToConstant: 50.scale),
            rating2View.heightAnchor.constraint(equalToConstant: 50.scale),
            rating2View.leadingAnchor.constraint(equalTo: rating1View.trailingAnchor, constant: 10.scale),
            rating2View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rating3View.widthAnchor.constraint(equalToConstant: 50.scale),
            rating3View.heightAnchor.constraint(equalToConstant: 50.scale),
            rating3View.leadingAnchor.constraint(equalTo: rating2View.trailingAnchor, constant: 10.scale),
            rating3View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rating4View.widthAnchor.constraint(equalToConstant: 50.scale),
            rating4View.heightAnchor.constraint(equalToConstant: 50.scale),
            rating4View.leadingAnchor.constraint(equalTo: rating3View.trailingAnchor, constant: 10.scale),
            rating4View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rating5View.widthAnchor.constraint(equalToConstant: 50.scale),
            rating5View.heightAnchor.constraint(equalToConstant: 50.scale),
            rating5View.leadingAnchor.constraint(equalTo: rating4View.trailingAnchor, constant: 10.scale),
            rating5View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RatingView {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Feedback.Star.Empty"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
