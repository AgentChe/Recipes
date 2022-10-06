//
//  ChallengeProgressView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeProgressView: UIView {
    lazy var label = makeLabel()
    
    private lazy var totalLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 44.scale, height: 44.scale)
    }
}

// MARK: Public
extension ChallengeProgressView {
    func setup(progress: Int) {
        trackLayer.strokeEnd = CGFloat(progress) / 100
        
        let attrs = TextAttributes()
            .textColor(Appearance.secondary2)
            .font(Fonts.PlusJakartaSans.bold(size: 10.scale))
            .lineHeight(12.6.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        label.attributedText = String(format: "%i%%", progress).attributed(with: attrs)
    }
}

// MARK: Private
private extension ChallengeProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: intrinsicContentSize.width / 2,
                                                           y: intrinsicContentSize.height / 2),
                                        radius: 20.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        
        totalLayer.path = circularPath.cgPath
        totalLayer.fillColor = UIColor.clear.cgColor
        totalLayer.lineCap = .round
        totalLayer.lineWidth = 4.scale
        totalLayer.strokeColor = Appearance.secondary5.cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 4.scale
        trackLayer.strokeColor = Appearance.secondary2.cgColor
        trackLayer.strokeStart = 0
        
        layer.addSublayer(totalLayer)
        layer.addSublayer(trackLayer)
    }
}

// MARK: Make constraints
private extension ChallengeProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
