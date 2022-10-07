//
//  LibraryTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit

protocol LibraryTableDelegate: AnyObject {
    func libraryTableDidTapped(recipe: RecipeCover)
    func libraryTableDidTappedMenu(recipe: RecipeCover)
}

final class LibraryTableView: UITableView {
    weak var mainDelegate: LibraryTableDelegate?
    
    private lazy var elements = [LibraryTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LibraryTableView {
    func setup(elements: [LibraryTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension LibraryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .recipe(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LibraryTableRecipeCell.self)) as! LibraryTableRecipeCell
            cell.setup(element: element) { [weak self] in
                self?.mainDelegate?.libraryTableDidTappedMenu(recipe: element.recipe)
            }
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: LibraryTableSeparatorCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension LibraryTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .recipe:
            return 65.scale
        case .separator:
            return 1.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .recipe(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.libraryTableDidTapped(recipe: element.recipe)
    }
}

// MARK: Private
private extension LibraryTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(LibraryTableRecipeCell.self, forCellReuseIdentifier: String(describing: LibraryTableRecipeCell.self))
        register(LibraryTableSeparatorCell.self, forCellReuseIdentifier: String(describing: LibraryTableSeparatorCell.self))
        
        dataSource = self
        delegate = self
    }
}
