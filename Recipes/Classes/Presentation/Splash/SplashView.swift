//
//  SplashView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var animateView = makeAnimateView()
    lazy var preloader = makePreloader()
    lazy var preloaderLabel = makeLabel()
    
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
private extension SplashView {
    func initialize() {
        backgroundColor = Appearance.primaryGreen
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            animateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animateView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -54.scale : -34.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            preloaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            preloaderLabel.bottomAnchor.constraint(equalTo: preloader.topAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeAnimateView() -> SplashAnimateLampView {
        let view = SplashAnimateLampView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale), color: .white)
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
}
