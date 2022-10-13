//
//  FeedbackTextView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit

final class FeedbackTextView: UIView {
    enum State {
        case none, focus
    }
    
    lazy var textView = makeTextView()
    lazy var placeholderLabel = makePlaceholderLabel()
    
    var editing: (() -> Void)?
    
    private let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        
        makeConstraints()
        textViewDidChange(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FeedbackTextView {
    func setup(text: String?) {
        textView.text = text
        
        textViewDidChange(textView)
    }
}

// MARK: UITextViewDelegate
extension FeedbackTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        editing?()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView === self.textView else {
            return
        }
        
        color(at: .focus)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView === self.textView else {
            return
        }
        
        color(at: .none)
    }
}

// MARK: Private
private extension FeedbackTextView {
    func color(at state: State) {
        switch state {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        case .focus:
            layer.borderWidth = 3.scale
            layer.borderColor = Appearance.primaryYellow.cgColor
        }
    }
}

// MARK: Make constraints
private extension FeedbackTextView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackTextView {
    func makeTextView() -> UITextView {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textColor(Appearance.black)
        
        let view = UITextView()
        view.backgroundColor = UIColor.clear
        view.typingAttributes = attrs.dictionary
        view.showsVerticalScrollIndicator = false
        view.textContainerInset = UIEdgeInsets(top: 20.scale, left: 17.scale, bottom: 20.scale, right: 17.scale)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textColor(Appearance.black.withAlphaComponent(0.5))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = placeholder.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
