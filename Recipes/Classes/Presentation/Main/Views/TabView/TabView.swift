//
//  TabView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case forYou, library, explore
    }
    
    lazy var forYouItem = makeItem(name: "Main.ForYou")
    lazy var libraryItem = makeItem(name: "Main.Library")
    lazy var exploreItem = makeItem(name: "Main.Explore")
    
    var selectedTab = Tab.forYou {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        [
            forYouItem,
            libraryItem,
            exploreItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .forYou:
            forYouItem.mode = .selected
        case .library:
            libraryItem.mode = .selected
        case .explore:
            exploreItem.mode = .selected
        }
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            forYouItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            forYouItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            forYouItem.topAnchor.constraint(equalTo: topAnchor),
            forYouItem.widthAnchor.constraint(equalTo: libraryItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            libraryItem.leadingAnchor.constraint(equalTo: forYouItem.trailingAnchor),
            libraryItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            libraryItem.topAnchor.constraint(equalTo: topAnchor),
            libraryItem.widthAnchor.constraint(equalTo: exploreItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exploreItem.leadingAnchor.constraint(equalTo: libraryItem.trailingAnchor),
            exploreItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            exploreItem.topAnchor.constraint(equalTo: topAnchor),
            exploreItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(name: String) -> TabItemView {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 12.scale))
            .textColor(Appearance.black)
            .lineHeight(12.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = TabItemView()
        view.backgroundColor = UIColor.clear
        view.iconView.image = UIImage(named: name)
        view.label.attributedText = name.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
