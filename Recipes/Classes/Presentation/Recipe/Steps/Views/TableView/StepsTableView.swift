//
//  StepsTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit

protocol StepsTableDelegate: AnyObject {
    func stepsTableDidTapped(step: RecipeStep)
}

final class StepsTableView: UITableView {
    weak var mainDelegate: StepsTableDelegate?
    
    private lazy var elements = [StepsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Pubic
extension StepsTableView {
    func setup(elements: [StepsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension StepsTableView: UITableViewDataSource {
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
        case .step(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StepTableCell.self)) as! StepTableCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension StepsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset:
            return 16.scale
        case .step:
            return 95.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .step(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.stepsTableDidTapped(step: element.step)
    }
}

// MARK: Private
private extension StepsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(StepTableCell.self, forCellReuseIdentifier: String(describing: StepTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
