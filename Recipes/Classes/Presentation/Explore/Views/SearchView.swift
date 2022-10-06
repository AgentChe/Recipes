//
//  SearchView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchView: UIView {
    enum State {
        case none, focus
    }
    
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    lazy var clearButton = makeClearButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var containerWidthConstraint = NSLayoutConstraint()
    
    private lazy var state = BehaviorRelay(value: State.none)
    private lazy var text = BehaviorRelay(value: "")
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        textEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SearchView {
    func setup(popularRequest: String) {
        textField.text = popularRequest
        textEditing()
    }
    
    var changedState: Signal<State> {
        state.asSignal(onErrorSignalWith: .never())
    }
    
    var changedText: Signal<String> {
        text.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField === self.textField else {
            return
        }
        
        state.accept(.focus)
    }
}

// MARK: Private
private extension SearchView {
    func initialize() {
        changedState
            .emit(to: Binder(self) { base, state in
                base.changed(state: state, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func cancelTapped() {
        textField.resignFirstResponder()
        
        textField.text = ""
        textEditing()
        
        state.accept(.none)
    }
    
    @objc
    func clearTapped() {
        textField.text = ""
        textEditing()
    }
    
    @objc
    func textEditing() {
        clearButton.isHidden = (textField.text ?? "").isEmpty
        
        text.accept(textField.text ?? "")
    }
    
    func changed(state: State, animated: Bool) {
        cancelButton.isHidden = state == .none
        
        containerWidthConstraint.isActive = false
        containerWidthConstraint.constant = state == .focus ? 280.scale : 343.scale
        containerWidthConstraint.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
}

// MARK: Make constraints
private extension SearchView {
    func makeConstraints() {
        containerWidthConstraint = container.widthAnchor.constraint(equalToConstant: 343.scale)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerWidthConstraint
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 40.scale),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -44.scale),
            textField.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 22.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 22.scale),
            clearButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            clearButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 21.scale),
            cancelButton.widthAnchor.constraint(equalToConstant: 54.scale),
            cancelButton.leadingAnchor.constraint(equalTo: container.trailingAnchor, constant: 10.scale),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let view = PaddingTextField()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.textPadding = UIEdgeInsets.zero
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Explore.Search.Placeholder".localized.attributed(with: placeholderAttrs)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeClearButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Explore.Search.Clear"), for: .normal)
        view.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = TapAreaButton()
        view.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.setAttributedTitle("Cancel".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
