//
//  TabView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case forYou, shopping, myRecipes, explore
    }
    
    lazy var forYouItem = makeItem(name: "Main.ForYou")
    lazy var shoppingItem = makeItem(name: "Main.Shopping")
    lazy var myRecipesItem = makeItem(name: "Main.MyRecipes")
    lazy var exploreItem = makeItem(name: "Main.Explore")
    lazy var separator = makeSeparator()
    
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
            shoppingItem,
            myRecipesItem,
            exploreItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .forYou:
            forYouItem.mode = .selected
        case .shopping:
            shoppingItem.mode = .selected
        case .myRecipes:
            myRecipesItem.mode = .selected
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
            forYouItem.widthAnchor.constraint(equalTo: shoppingItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shoppingItem.leadingAnchor.constraint(equalTo: forYouItem.trailingAnchor),
            shoppingItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            shoppingItem.topAnchor.constraint(equalTo: topAnchor),
            shoppingItem.widthAnchor.constraint(equalTo: myRecipesItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            myRecipesItem.leadingAnchor.constraint(equalTo: shoppingItem.trailingAnchor),
            myRecipesItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            myRecipesItem.topAnchor.constraint(equalTo: topAnchor),
            myRecipesItem.widthAnchor.constraint(equalTo: exploreItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exploreItem.leadingAnchor.constraint(equalTo: myRecipesItem.trailingAnchor),
            exploreItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            exploreItem.topAnchor.constraint(equalTo: topAnchor),
            exploreItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
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
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
