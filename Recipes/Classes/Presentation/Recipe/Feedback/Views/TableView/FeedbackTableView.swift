//
//  FeedbackTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

protocol FeedbackTableDelegate: AnyObject {
    func feedbackTableDidSelectedRating()
}

final class FeedbackTableView: UITableView {
    weak var mainDelegate: FeedbackTableDelegate?
    
    private lazy var elements = [FeedbackTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Pubic
extension FeedbackTableView {
    func setup(elements: [FeedbackTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension FeedbackTableView: UITableViewDataSource {
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
            let cell = dequeueReusableCell(withIdentifier: String(describing: FeedbackTableRecipeCell.self)) as! FeedbackTableRecipeCell
            cell.setup(element: element)
            return cell
        case .rating(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FeedbackTableRatingCell.self)) as! FeedbackTableRatingCell
            cell.setup(element: element.rating) { [weak self] rating in
                element.rating = rating
                self?.mainDelegate?.feedbackTableDidSelectedRating()
            }
            return cell
        case .improves(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FeedbackTableImproveCell.self)) as! FeedbackTableImproveCell
            cell.setup(element: element.improves) { improves in
                element.improves = improves
            }
            return cell
        case .whatBetter(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FeedbackTableBetterCell.self)) as! FeedbackTableBetterCell
            cell.setup(element: element.text) { text in
                element.text = text
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension FeedbackTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset:
            return 16.scale
        case .rating:
            return 114.scale
        case .improves:
            return 394.scale
        case .whatBetter:
            return 232.scale
        case .recipe:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension FeedbackTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(FeedbackTableRecipeCell.self, forCellReuseIdentifier: String(describing: FeedbackTableRecipeCell.self))
        register(FeedbackTableRatingCell.self, forCellReuseIdentifier: String(describing: FeedbackTableRatingCell.self))
        register(FeedbackTableImproveCell.self, forCellReuseIdentifier: String(describing: FeedbackTableImproveCell.self))
        register(FeedbackTableBetterCell.self, forCellReuseIdentifier: String(describing: FeedbackTableBetterCell.self))
        
        dataSource = self
        delegate = self
    }
}
