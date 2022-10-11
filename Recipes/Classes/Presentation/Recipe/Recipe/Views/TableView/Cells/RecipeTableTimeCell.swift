//
//  RecipeTableTimeCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeTableTimeCell: UITableViewCell {
    lazy var preparingTimeView = makePreparingTimeView()
    lazy var cookingTimeView = makeCookingTimeView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RecipeTableTimeCell {
    func setup(element: RecipeTableTimeElement) {
        if let preparingTime = element.timePreparing {
            preparingTimeView.setup(time: preparingTime)
        }
        if let cookingTime = element.timeCooking {
            cookingTimeView.setup(time: cookingTime)
        }
        
        preparingTimeView.isHidden = element.timePreparing == nil
        cookingTimeView.isHidden = element.timeCooking == nil
        
        NSLayoutConstraint.activate([
            preparingTimeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cookingTimeView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        let haveBoth = (element.timePreparing != nil) && (element.timeCooking != nil)
        if haveBoth {
            NSLayoutConstraint.activate([
                preparingTimeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 109.scale),
                cookingTimeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 198.scale)
            ])
        } else if (element.timePreparing != nil) {
            NSLayoutConstraint.activate([
                preparingTimeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        } else if (element.timeCooking != nil) {
            NSLayoutConstraint.activate([
                cookingTimeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }
    }
}

// MARK: Private
private extension RecipeTableTimeCell {
    func initialize() {
        backgroundColor = Appearance.background
        contentView.backgroundColor = Appearance.background
        
        selectionStyle = .none
    }
}

// MARK: Lazy initialization
private extension RecipeTableTimeCell {
    func makePreparingTimeView() -> RecipeTimeView {
        let view = RecipeTimeView(iconName: "Recipe.Time.Preparing")
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCookingTimeView() -> RecipeTimeView {
        let view = RecipeTimeView(iconName: "Recipe.Time.Cooking")
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
