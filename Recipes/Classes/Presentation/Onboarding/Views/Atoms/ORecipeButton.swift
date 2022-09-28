//
//  ORecipeButton.swift
//  Recipes
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

final class ORecipeButton: UIButton {
    lazy var iconView = makeIconView()
    
    private let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ORecipeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 46.scale),
            iconView.heightAnchor.constraint(equalToConstant: 43.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ORecipeButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
