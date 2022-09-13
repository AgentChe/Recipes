//
//  ContentMediator.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import RxCocoa

protocol ContentMediatorDelegate: AnyObject {
    func contentMediatorDidSaved(book: BookCover)
    func contentMediatorDidRemovedSaved(book: BookCover)
    func contentMediatorDidUpdated(bookReadingProgress: BookReadingProgress)
    func contentMediatorDidRemovedProgress(bookId: Int)
    func contentMediatorDidDownloaded(localBook: LocalBook)
    func contentMediatorDidRemovedDownload(bookId: Int)
}

final class ContentMediator {
    static let shared = ContentMediator()
    
    private var delegates = [Weak<ContentMediatorDelegate>]()
    
    private lazy var bookDidSavedTrigger = PublishRelay<BookCover>()
    private lazy var bookDidRemoveFromSavedTrigger = PublishRelay<BookCover>()
    private lazy var bookReadingProgressUpdatedTrigger = PublishRelay<BookReadingProgress>()
    private lazy var bookDidRemovedProgressTrigger = PublishRelay<Int>()
    private lazy var bookDownloadedTrigger = PublishRelay<LocalBook>()
    private lazy var bookDidRemovedDownloadTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension ContentMediator {
    func notifyAboutSaved(book: BookCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidSaved(book: book)
            }
            
            self?.bookDidSavedTrigger.accept(book)
        }
    }
    
    func notifyAboutRemoveSaved(book: BookCover) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedSaved(book: book)
            }
            
            self?.bookDidRemoveFromSavedTrigger.accept(book)
        }
    }
    
    func notifyAboutUpdate(bookReadingProgress: BookReadingProgress) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidUpdated(bookReadingProgress: bookReadingProgress)
            }
            
            self?.bookReadingProgressUpdatedTrigger.accept(bookReadingProgress)
        }
    }
    
    func notifyAboutUpdateRemovedProgress(bookId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedProgress(bookId: bookId)
            }
            
            self?.bookDidRemovedProgressTrigger.accept(bookId)
        }
    }
    
    func notifyAboutUpdate(bookDownloaded: LocalBook) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidDownloaded(localBook: bookDownloaded)
            }
            
            self?.bookDownloadedTrigger.accept(bookDownloaded)
        }
    }
    
    func notifyAboutRemovedDownload(bookId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedDownload(bookId: bookId)
            }
            
            self?.bookDidRemovedDownloadTrigger.accept(bookId)
        }
    }
}

// MARK: Public (Triggers)
extension ContentMediator {
    var bookDidSaved: Signal<BookCover> {
        bookDidSavedTrigger.asSignal()
    }
    
    var bookDidRemoveFromSaved: Signal<BookCover> {
        bookDidRemoveFromSavedTrigger.asSignal()
    }
    
    var bookReadingProgressUpdated: Signal<BookReadingProgress> {
        bookReadingProgressUpdatedTrigger.asSignal()
    }
    
    var bookDidRemovedProgress: Signal<Int> {
        bookDidRemovedProgressTrigger.asSignal()
    }
    
    var bookDownloaded: Signal<LocalBook> {
        bookDownloadedTrigger.asSignal()
    }
    
    var bookDidRemovedDownload: Signal<Int> {
        bookDidRemovedDownloadTrigger.asSignal()
    }
}

// MARK: Public (Observer)
extension ContentMediator {
    func add(delegate: ContentMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ContentMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: ContentMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
