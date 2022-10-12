//
//  RecipeCPFCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeCPFCell: UITableViewCell {
    lazy var carbsView = makeCarbsView()
    lazy var proteinView = makeProteinView()
    lazy var fatsView = makeFatsView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RecipeCPFCell {
    func setup(element: RecipeTableCPFElement) {
        carbsView.setup(cgp: element.carbs)
        proteinView.setup(cgp: element.protein)
        fatsView.setup(cgp: element.fats)
    }
}

// MARK: Private
private extension RecipeCPFCell {
    func initialize() {
        backgroundColor = Appearance.background
        contentView.backgroundColor = Appearance.background
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RecipeCPFCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            carbsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 43.scale),
            carbsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            proteinView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 147.scale),
            proteinView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fatsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 251.scale),
            fatsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeCPFCell {
    func makeCarbsView() -> RecipeCPFView {
        let view = RecipeCPFView(name: "Recipe.Carbs".localized, color: Appearance.secondary1)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProteinView() -> RecipeCPFView {
        let view = RecipeCPFView(name: "Recipe.Protein".localized, color: Appearance.secondary3)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeFatsView() -> RecipeCPFView {
        let view = RecipeCPFView(name: "Recipe.Fats".localized, color: Appearance.primaryYellow)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
