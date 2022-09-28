//
//  ORecipeImageCollectionView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 25.08.2022.
//

import UIKit
import Kingfisher

protocol ORecipeImageCollectionViewDelegate: AnyObject {
    func recipeImageCollectionDidChange(frontRecipe: RecipeCover)
}

final class ORecipeImageCollectionView: UIView {
    weak var delegate: ORecipeImageCollectionViewDelegate?
    
    private lazy var frontRect = CGRect(origin: CGPoint.zero,
                                        size: CGSize(width: 241.scale, height: 249.scale))
    private lazy var middleRect = CGRect(origin: CGPoint(x: 15.scale, y: -16.scale.scale),
                                         size: CGSize(width: 211.scale, height: 218.scale))
    private lazy var backRect = CGRect(origin: CGPoint(x: 30.scale, y: -32.scale),
                                       size: CGSize(width: 181.scale, height: 187.scale))
    
    private lazy var waitingToBeDisplayedRecipes = [RecipeCover]()
    private lazy var likedRecipes = [RecipeCover]()
    
    private lazy var imageViews = [RecipeCover: UIImageView]()
    
    private var frontRecipe: RecipeCover?
    private var middleRecipe: RecipeCover?
    private var backRecipe: RecipeCover?
    
    private var completion: (([RecipeCover]) -> Void)?
    
    override var intrinsicContentSize: CGSize {
        frontRect.size
    }
}

// MARK: Public
extension ORecipeImageCollectionView {
    func setup(recipes: [RecipeCover], completion: @escaping ([RecipeCover]) -> Void) {
        self.completion = completion
        
        initialize(recipes: recipes)
        createFirstViews()
        notifyAboutChangeFront()
    }
    
    func like() {
        markAsLiked()
        proceed(orientation: .right)
    }
    
    func dislike() {
        proceed(orientation: .left)
    }
}

// MARK: Private
private extension ORecipeImageCollectionView {
    enum Orientation {
        case left, right
    }
    
    func markAsLiked() {
        guard let frontRecipe = frontRecipe else {
            return
        }
        
        likedRecipes.append(frontRecipe)
    }
    
    func notifyAboutChangeFront() {
        guard let frontRecipe = frontRecipe else {
            return
        }
        
        delegate?.recipeImageCollectionDidChange(frontRecipe: frontRecipe)
    }
    
    func proceed(orientation: Orientation) {
        removeFront(orientation: orientation) { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.isCompleted() {
                self.completion?(self.likedRecipes)
                return
            }
            
            self.upRecipesLevel()
            self.updateViews()
            self.notifyAboutChangeFront()
        }
    }
    
    func removeFront(orientation: Orientation, completion: @escaping () -> Void) {
        guard let frontRecipe = frontRecipe, let frontView = imageViews[frontRecipe] else {
            return
        }
        
        var translationX = ((UIScreen.main.bounds.width - intrinsicContentSize.width) / 2) + intrinsicContentSize.width
        let translationY = intrinsicContentSize.height / 5
        var rotationAngle = 45 * CGFloat.pi / 180
        
        switch orientation {
        case .left:
            translationX = translationX * -1
            rotationAngle = rotationAngle * -1
        case .right:
            translationX = translationX * 1
            rotationAngle = rotationAngle * 1
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            frontView.frame.origin = CGPoint(x: translationX, y: translationY)
            frontView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            frontView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }, completion: { [weak self] result in
            frontView.removeFromSuperview()
            self?.imageViews.removeValue(forKey: frontRecipe)
            self?.frontRecipe = nil
            
            completion()
        })
    }
    
    func isCompleted() -> Bool {
        // Если middleRecipe nil, это значит, что был оценен последний frontRecipe и больше книг на оценку нет
        guard middleRecipe != nil else {
            return true
        }
        
        return likedRecipes.count == 3
    }
    
    func upRecipesLevel() {
        frontRecipe = middleRecipe
        middleRecipe = backRecipe
        backRecipe = waitingToBeDisplayedRecipes.isEmpty ? nil : waitingToBeDisplayedRecipes.removeFirst()
    }
    
    func updateViews() {
        var frontView: UIImageView?
        var middleView: UIImageView?
        
        if let frontRecipe = frontRecipe {
            frontView = imageViews[frontRecipe]
        }
        
        if let middleRecipe = middleRecipe {
            middleView = imageViews[middleRecipe]
        }
        
        if let backRecipe = backRecipe {
            let view = makeImageView(recipe: backRecipe)
            view.frame = backRect
            sendSubviewToBack(view)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            frontView?.frame = self.frontRect
            middleView?.frame = self.middleRect
        })
    }
    
    func initialize(recipes: [RecipeCover]) {
        let limit = Array(recipes.shuffled().prefix(6))
        
        let display = Array(limit.prefix(3))
        
        frontRecipe = display[safe: 0]
        middleRecipe = display[safe: 1]
        backRecipe = display[safe: 2]
        
        if limit.indices.contains(3) {
            waitingToBeDisplayedRecipes = Array(limit.suffix(from: 3))
        }
    }
    
    func createFirstViews() {
        imageViews.forEach { $0.value.removeFromSuperview() }
        imageViews = [:]
        
        if let backRecipe = backRecipe {
            makeImageView(recipe: backRecipe).frame = backRect
        }
        
        if let middleRecipe = middleRecipe {
            makeImageView(recipe: middleRecipe).frame = middleRect
        }
        
        if let frontRecipe = frontRecipe {
            makeImageView(recipe: frontRecipe).frame = frontRect
        }
    }
    
    func makeImageView(recipe: RecipeCover) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.kf.setImage(with: recipe.imageUrl)
        addSubview(view)
        imageViews[recipe] = view
        return view
    }
}
