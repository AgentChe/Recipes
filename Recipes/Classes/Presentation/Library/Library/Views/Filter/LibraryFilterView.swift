//
//  LibraryFilterView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit

final class LibraryFilterView: UIView {
    enum Filter {
        case saved, history
    }
    
    lazy var filter: Filter = .saved {
        didSet {
            update()
        }
    }
    
    lazy var savedButton = makeButton(title: "Library.Saved".localized)
    lazy var historyButton = makeButton(title: "Library.History".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LibraryFilterView {
    func update() {
        savedButton.marked = filter == .saved
        historyButton.marked = filter == .history
    }
}

// MARK: Make constraints
private extension LibraryFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            savedButton.widthAnchor.constraint(equalToConstant: 48.scale),
            savedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            savedButton.topAnchor.constraint(equalTo: topAnchor),
            savedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            historyButton.widthAnchor.constraint(equalToConstant: 78.scale),
            historyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 84.scale),
            historyButton.topAnchor.constraint(equalTo: topAnchor),
            historyButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LibraryFilterView {
    func makeButton(title: String) -> LibraryFilterButton {
        let view = LibraryFilterButton(title: title)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
