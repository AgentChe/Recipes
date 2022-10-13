//
//  ReaderTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.10.2022.
//

import UIKit

final class ReaderTableView: UITableView {
    private lazy var elements = [ReaderTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReaderTableView {
    func setup(elements: [ReaderTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ReaderTableView: UITableViewDataSource {
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
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReaderTitleCell.self)) as! ReaderTitleCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReaderTextCell.self)) as! ReaderTextCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReaderImageCell.self)) as! ReaderImageCell
            cell.setup(element: element)
            return cell
        case .lastStepTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReaderLastStepTitleCell.self)) as! ReaderLastStepTitleCell
            cell.setup(element: element)
            return cell
        case .lastStepText:
            return dequeueReusableCell(withIdentifier: String(describing: ReaderLastStepTextCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension ReaderTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .image:
            return 205.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension ReaderTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ReaderTitleCell.self, forCellReuseIdentifier: String(describing: ReaderTitleCell.self))
        register(ReaderTextCell.self, forCellReuseIdentifier: String(describing: ReaderTextCell.self))
        register(ReaderImageCell.self, forCellReuseIdentifier: String(describing: ReaderImageCell.self))
        register(ReaderLastStepTextCell.self, forCellReuseIdentifier: String(describing: ReaderLastStepTextCell.self))
        register(ReaderLastStepTitleCell.self, forCellReuseIdentifier: String(describing: ReaderLastStepTitleCell.self))
        
        dataSource = self
        delegate = self
    }
}
