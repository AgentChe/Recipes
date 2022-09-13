//
//  SplashAnimateLampView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class SplashAnimateLampView: UIView {
    lazy var lightLampView = makeLigthLampView()
    lazy var yellowLampView = makeYellowLampView()
    lazy var bookView = makeBookView()
    
    private lazy var lightLampTopConstraint = NSLayoutConstraint()
    private lazy var bookBottomConstraint = NSLayoutConstraint()
    
    private lazy var bookViewHeight = ScreenSize.isIphoneXFamily ? 110.scale : 90.scale
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initalize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: ScreenSize.isIphoneXFamily ? 157.scale : 129.scale,
               height: ScreenSize.isIphoneXFamily ? 547.scale : 409.scale)
    }
}

// MARK: Public
extension SplashAnimateLampView {
    func start() {
        animateLight { [weak self] in
            self?.animateYellow {
                self?.animateBook()
            }
        }
    }
}

// MARK: Private
private extension SplashAnimateLampView {
    func initalize() {
        yellowLampView.alpha = 0
        bookView.alpha = 0
    }
    
    func animateLight(completion: @escaping () -> Void) {
        lightLampTopConstraint.isActive = false
        lightLampTopConstraint.constant = 0
        lightLampTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
    
    func animateYellow(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.yellowLampView.alpha = 1
        }, completion: { result in
            completion()
        })
    }
    
    func animateBook() {
        bookView.alpha = 1
        
        bookBottomConstraint.isActive = false
        bookBottomConstraint.constant = 0
        bookBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
}

// MARK: Make constraints
private extension SplashAnimateLampView {
    func makeConstraints() {
        lightLampTopConstraint = lightLampView.topAnchor.constraint(equalTo: topAnchor, constant: -intrinsicContentSize.height)
        NSLayoutConstraint.activate([
            lightLampView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lightLampView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lightLampView.heightAnchor.constraint(equalToConstant: intrinsicContentSize.height),
            lightLampTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            yellowLampView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yellowLampView.trailingAnchor.constraint(equalTo: trailingAnchor),
            yellowLampView.heightAnchor.constraint(equalToConstant: intrinsicContentSize.height),
            yellowLampView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        bookBottomConstraint = bookView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bookViewHeight)
        NSLayoutConstraint.activate([
            bookView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 135.scale : 111.scale),
            bookView.heightAnchor.constraint(equalToConstant: bookViewHeight),
            bookView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookBottomConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension SplashAnimateLampView {
    func makeLigthLampView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .bottom
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Splash.LightLamp.X" : "Splash.LightLamp.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeYellowLampView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .bottom
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Splash.YellowLamp.X" : "Splash.YellowLamp.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBookView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .bottom
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Splash.Book.X" : "Splash.Book.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        yellowLampView.addSubview(view)
        return view
    }
}
