//
//  ODietsTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 28.09.2022.
//

import UIKit

final class ODietsTableView: UITableView {
    var changeSelection: (() -> Void)?
    
    lazy var elements = [ODietsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ODietsTableView {
    func setup(elements: [ODietsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ODietsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ODietsTableCell.self)) as! ODietsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ODietsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard (elements.count - 1) == indexPath.row else {
            return 88.scale
        }
        
        return 72.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
         }
        
        changeSelection?()
    }
}

// MARK: Private
private extension ODietsTableView {
    func initialize() {
        register(ODietsTableCell.self, forCellReuseIdentifier: String(describing: ODietsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
