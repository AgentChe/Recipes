//
//  RecipeCPFView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeCPFView: UIView {
    lazy var progressView = makeProgressView()
    lazy var gramLabel = makeLabel()
    lazy var percentLabel = makeLabel()
    lazy var nameLabel = makeNameLabel()
    
    private let name: String
    private let color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 80.scale, height: 114.scale)
    }
}

// MARK: Public
extension RecipeCPFView {
    func setup(cgp: RecipeCPF?) {
        if let cgp = cgp {
            fill(cgp: cgp)
        } else {
            fillAsEmpty()
        }
    }
}

// MARK: Private
private extension RecipeCPFView {
    func fill(cgp: RecipeCPF) {
        progressView.setup(progress: cgp.percent)
        
        let gramAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        let gram = String(format: "Recipe.Gram".localized, cgp.gram)
        gramLabel.attributedText = gram.attributed(with: gramAttrs)
        
        let percentAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 12.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        let percent = String(format: "Recipe.Percent".localized, cgp.percent)
        percentLabel.attributedText = percent.attributed(with: percentAttrs)
        
        let nameAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        nameLabel.attributedText = name.attributed(with: nameAttrs)
    }
    
    func fillAsEmpty() {
        progressView.setup(progress: 0)
        
        gramLabel.attributedText = nil
        percentLabel.attributedText = nil
        
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        nameLabel.attributedText = "Recipe.Undetermined".localized.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension RecipeCPFView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 80.scale),
            progressView.heightAnchor.constraint(equalToConstant: 80.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gramLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            gramLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.topAnchor.constraint(equalTo: gramLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeCPFView {
    func makeProgressView() -> CircleProgressView {
        let view = CircleProgressView(arcCenter: CGPoint(x: 40.scale, y: 40.scale),
                                      radius: 36.scale,
                                      lineWidth: 8.scale,
                                      circleColor: color.withAlphaComponent(0.3),
                                      trackColor: color)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
