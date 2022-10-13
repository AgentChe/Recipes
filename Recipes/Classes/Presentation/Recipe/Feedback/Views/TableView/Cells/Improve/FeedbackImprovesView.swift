//
//  FeedbackImprovesView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class FeedbackImprovesView: UIView {
    var changeSelection: (([Int]) -> Void)?
    
    lazy var button1 = makeButton(title: "Feedback.Improve1".localized, number: 1)
    lazy var button2 = makeButton(title: "Feedback.Improve2".localized, number: 2)
    lazy var button3 = makeButton(title: "Feedback.Improve3".localized, number: 3)
    lazy var button4 = makeButton(title: "Feedback.Improve4".localized, number: 4)
    lazy var button5 = makeButton(title: "Feedback.Improve5".localized, number: 5)
    lazy var button6 = makeButton(title: "Feedback.Improve6".localized, number: 6)
    lazy var button7 = makeButton(title: "Feedback.Improve7".localized, number: 7)
    
    private lazy var views = [
        button1,
        button2,
        button3,
        button4,
        button5,
        button6,
        button7
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FeedbackImprovesView {
    func setup(numbers: [Int]) {
        views.forEach {
            $0.marked = numbers.contains($0.number)
        }
    }
}

// MARK: Private
private extension FeedbackImprovesView {
    @objc
    func tapped(sender: UIButton) {
        guard let improveButton = sender as? FeedbackImproveButton else {
            return
        }
        
        improveButton.marked.toggle()
        
        let numbers = views.filter { $0.marked }.map { $0.number }
        
        changeSelection?(numbers)
    }
}

// MARK: Make constraints
private extension FeedbackImprovesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 253.scale),
            button1.heightAnchor.constraint(equalToConstant: 49.scale),
            button1.leadingAnchor.constraint(equalTo: leadingAnchor),
            button1.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button2.widthAnchor.constraint(equalToConstant: 185.scale),
            button2.heightAnchor.constraint(equalToConstant: 49.scale),
            button2.leadingAnchor.constraint(equalTo: leadingAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button3.widthAnchor.constraint(equalToConstant: 179.scale),
            button3.heightAnchor.constraint(equalToConstant: 49.scale),
            button3.leadingAnchor.constraint(equalTo: leadingAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button4.widthAnchor.constraint(equalToConstant: 153.scale),
            button4.heightAnchor.constraint(equalToConstant: 49.scale),
            button4.leadingAnchor.constraint(equalTo: leadingAnchor),
            button4.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button5.widthAnchor.constraint(equalToConstant: 142.scale),
            button5.heightAnchor.constraint(equalToConstant: 49.scale),
            button5.leadingAnchor.constraint(equalTo: leadingAnchor),
            button5.topAnchor.constraint(equalTo: button4.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button6.widthAnchor.constraint(equalToConstant: 112.scale),
            button6.heightAnchor.constraint(equalToConstant: 49.scale),
            button6.leadingAnchor.constraint(equalTo: button5.trailingAnchor, constant: 12.scale),
            button6.topAnchor.constraint(equalTo: button4.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button7.widthAnchor.constraint(equalToConstant: 155.scale),
            button7.heightAnchor.constraint(equalToConstant: 49.scale),
            button7.leadingAnchor.constraint(equalTo: leadingAnchor),
            button7.topAnchor.constraint(equalTo: button5.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackImprovesView {
    func makeButton(title: String, number: Int) -> FeedbackImproveButton {
        let view = FeedbackImproveButton()
        view.title = title
        view.number = number
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
