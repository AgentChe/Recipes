//
//  OBookImageCollectionView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 25.08.2022.
//

import UIKit
import Kingfisher

final class OBookImageCollectionView: UIView {
    private lazy var frontRect = CGRect(origin: CGPoint.zero,
                                        size: CGSize(width: 221.scale, height: 267.scale))
    private lazy var middleRect = CGRect(origin: CGPoint(x: 15.scale, y: -16.scale.scale),
                                         size: CGSize(width: 190.scale, height: 220.scale))
    private lazy var backRect = CGRect(origin: CGPoint(x: 30.scale, y: -32.scale),
                                       size: CGSize(width: 160.scale, height: 194.scale))
    
    private lazy var waitingToBeDisplayedBooks = [BookCover]()
    private lazy var likedBooks = [BookCover]()
    
    private lazy var imageViews = [BookCover: BookImageView]()
    
    private var frontBook: BookCover?
    private var middleBook: BookCover?
    private var backBook: BookCover?
    
    private var completion: (([BookCover]) -> Void)?
    
    override var intrinsicContentSize: CGSize {
        frontRect.size
    }
}

// MARK: Public
extension OBookImageCollectionView {
    func setup(books: [BookCover], completion: @escaping ([BookCover]) -> Void) {
        self.completion = completion
        
        initialize(books: books)
        createFirstViews()
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
private extension OBookImageCollectionView {
    enum Orientation {
        case left, right
    }
    
    func markAsLiked() {
        guard let frontBook = frontBook else {
            return
        }
        
        likedBooks.append(frontBook)
    }
    
    func proceed(orientation: Orientation) {
        removeFront(orientation: orientation) { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.isCompleted() {
                self.completion?(self.likedBooks)
                return
            }
            
            self.upBooksLevel()
            self.updateViews()
        }
    }
    
    func removeFront(orientation: Orientation, completion: @escaping () -> Void) {
        guard let frontBook = frontBook, let frontView = imageViews[frontBook] else {
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
            self?.imageViews.removeValue(forKey: frontBook)
            self?.frontBook = nil
            
            completion()
        })
    }
    
    func isCompleted() -> Bool {
        // Если middleBook nil, это значит, что был оценен последний frontBook и больше книг на оценку нет
        guard middleBook != nil else {
            return true
        }
        
        return likedBooks.count == 3
    }
    
    func upBooksLevel() {
        frontBook = middleBook
        middleBook = backBook
        backBook = waitingToBeDisplayedBooks.isEmpty ? nil : waitingToBeDisplayedBooks.removeFirst()
    }
    
    func updateViews() {
        var frontView: UIImageView?
        var middleView: UIImageView?
        
        if let frontBook = frontBook {
            frontView = imageViews[frontBook]
        }
        
        if let middleBook = middleBook {
            middleView = imageViews[middleBook]
        }
        
        if let backBook = backBook {
            let view = makeImageView(book: backBook)
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
    
    func initialize(books: [BookCover]) {
        let limit = Array(books.shuffled().prefix(6))
        
        let display = Array(limit.prefix(3))
        
        frontBook = display[safe: 0]
        middleBook = display[safe: 1]
        backBook = display[safe: 2]
        
        if limit.indices.contains(3) {
            waitingToBeDisplayedBooks = Array(limit.suffix(from: 3))
        }
    }
    
    func createFirstViews() {
        imageViews.forEach { $0.value.removeFromSuperview() }
        imageViews = [:]
        
        if let backBook = backBook {
            makeImageView(book: backBook).frame = backRect
        }
        
        if let middleBook = middleBook {
            makeImageView(book: middleBook).frame = middleRect
        }
        
        if let frontBook = frontBook {
            makeImageView(book: frontBook).frame = frontRect
        }
    }
    
    func makeImageView(book: BookCover) -> BookImageView {
        let view = BookImageView()
        view.kf.setImage(with: book.imageUrl)
        addSubview(view)
        imageViews[book] = view
        return view
    }
}
