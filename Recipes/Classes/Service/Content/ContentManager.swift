//
//  ContentManager.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import Foundation

protocol ContentManagerProtocol: AnyObject {
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]>
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]>
    func obtainBookKit(bookId: Int) -> Single<BookKit?>
    func obtainForYouKit() -> Single<ForYouKit?>
    func save(book: BookCover) -> Single<Bool>
    func removeSaved(book: BookCover) -> Single<Bool>
    func obtainSavedBooksCover() -> Single<[BookCover]>
    func obtainExploreKit() -> Single<ExploreKit?>
    func searchBooks(at: String) -> Single<[BookCover]>
    func obtainCategoryBooksCover(categoryId: Int) -> Single<[BookCover]>
    func obtainRankingBooksCover(rankingId: Int) -> Single<[BookCover]>
    func obtainReadingBooks() -> Single<[BookReadingProgress]>
    func set(bookReadingProgress: BookReadingProgress) -> Single<Void>
    func removeBookProgress(bookId: Int) -> Single<Void>
    func feedback(bookId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?,
                  whatLearn: String?) -> Single<Bool>
    func obtainDownloadBooks() -> Single<[LocalBook]>
    func download(book: Book, delegate: DownloadBookDelegate?) -> Single<LocalBook?>
    func removeDownload(bookId: Int) -> Single<Void>
    func obtainChallenge(id: Int) -> Single<Challenge?>
}

final class ContentManager: ContentManagerProtocol {
    enum Constants {
        static let categoriesKey = "content_manager_categories_key"
        static let rankingKey = "content_manager_ranking_key"
        static let readingBooksKey = "content_manager_reading_books_key"
        static let downloadBooksKey = "content_manager_download_books_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension ContentManager {
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]> {
        forceUpdate ? loadCategories() : cachedCategories()
    }
    
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]> {
        forceUpdate ? loadRankings() : cachedRankings()
    }
    
    func obtainBookKit(bookId: Int) -> Single<BookKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetBookKitRequest(userToken: userToken, bookId: bookId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetBookKitResponse.map(from: $0) }
    }
    
    func obtainForYouKit() -> Single<ForYouKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetForYouRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetForYouResponse.map(from: $0) }
    }
    
    func save(book: BookCover) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveBookRequest(userToken: userToken, bookId: book.id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SaveRemoveBookResponse.map(from: $0) }
            .do(onSuccess: { success in
                if success {
                    ContentMediator.shared.notifyAboutSaved(book: book)
                }
            })
    }
    
    func removeSaved(book: BookCover) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = RemoveSavedBookRequest(userToken: userToken, bookId: book.id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SaveRemoveBookResponse.map(from: $0) }
            .do(onSuccess: { success in
                if success {
                    ContentMediator.shared.notifyAboutRemoveSaved(book: book)
                }
            })
    }
    
    func obtainSavedBooksCover() -> Single<[BookCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSavedBooksRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSavedBooksResponse.map(from: $0) }
    }
    
    func obtainExploreKit() -> Single<ExploreKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetExploreKitRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetExploreKitResponse.map(from: $0) }
    }
    
    func searchBooks(at: String) -> Single<[BookCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SearchBooksRequest(userToken: userToken, search: at)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SearchBooksResponse.map(from: $0) }
    }
    
    func obtainCategoryBooksCover(categoryId: Int) -> Single<[BookCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCategoryBooksRequest(userToken: userToken, categoryId: categoryId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCategoryBooksResponse.map(from: $0) }
    }
    
    func obtainRankingBooksCover(rankingId: Int) -> Single<[BookCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetRankingBooksRequest(userToken: userToken, rankingId: rankingId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRankingBooksResponse.map(from: $0) }
    }
    
    func obtainReadingBooks() -> Single<[BookReadingProgress]> {
        Single<[BookReadingProgress]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.readingBooksKey),
                let books = try? JSONDecoder().decode([BookReadingProgress].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(books))
            
            return Disposables.create()
        }
    }
    
    func set(bookReadingProgress: BookReadingProgress) -> Single<Void> {
        obtainReadingBooks()
            .flatMap { readingBooks -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingBooks
                    
                    if let index = result.firstIndex(where: { $0.book.id == bookReadingProgress.book.id }) {
                        result[index] = bookReadingProgress
                    } else {
                        result.append(bookReadingProgress)
                    }
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.readingBooksKey)
                        
                        ContentMediator.shared.notifyAboutUpdate(bookReadingProgress: bookReadingProgress)
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func removeBookProgress(bookId: Int) -> Single<Void> {
        obtainReadingBooks()
            .flatMap { readingBooks -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingBooks
                    
                    if let index = result.firstIndex(where: { $0.book.id == bookId }) {
                        result.remove(at: index)
                        
                        if let data = try? JSONEncoder().encode(result) {
                            UserDefaults.standard.set(data, forKey: Constants.readingBooksKey)
                            
                            ContentMediator.shared.notifyAboutUpdateRemovedProgress(bookId: bookId)
                        }
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
    
    func feedback(bookId: Int,
                  rating: Int,
                  improves: [Int],
                  whatBetter: String?,
                  whatLearn: String?) -> Single<Bool> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = FeedbackRequest(userToken: userToken,
                                      bookId: bookId,
                                      rating: rating,
                                      improves: improves,
                                      whatBetter: whatBetter,
                                      whatLearn: whatLearn)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { FeedbackResponse.map(from: $0) }
    }
    
    func obtainDownloadBooks() -> Single<[LocalBook]> {
        Single<[LocalBook]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.downloadBooksKey),
                let books = try? JSONDecoder().decode([LocalBook].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(books))
            
            return Disposables.create()
        }
    }
    
    func download(book: Book, delegate: DownloadBookDelegate?) -> Single<LocalBook?> {
        Single<LocalBook?>
            .create { event in
                DownloadBooksQueue.shared.download(book: book, delegate: delegate) { localBook in
                    guard let localBook = localBook else {
                        event(.success(nil))
                        return
                    }

                    var books = [LocalBook]()
                    
                    if let data = UserDefaults.standard.data(forKey: Constants.downloadBooksKey) {
                        let decoded = try? JSONDecoder().decode([LocalBook].self, from: data)
                        books = decoded ?? []
                    }
                    
                    if let index = books.firstIndex(of: localBook) {
                        books[index] = localBook
                    } else {
                        books.append(localBook)
                    }
                    
                    if let data = try? JSONEncoder().encode(books) {
                        UserDefaults.standard.set(data, forKey: Constants.downloadBooksKey)
                    }
                    
                    ContentMediator.shared.notifyAboutUpdate(bookDownloaded: localBook)
                    
                    event(.success(localBook))
                }
                
                return Disposables.create()
            }
    }
    
    func removeDownload(bookId: Int) -> Single<Void> {
        obtainDownloadBooks()
            .flatMap { downloadedBooks -> Single<Void> in
                Single<Void>
                    .create { event in
                        var result = downloadedBooks
                        
                        if let index = result.firstIndex(where: { $0.original.id == bookId }) {
                            result.remove(at: index)
                            
                            if let data = try? JSONEncoder().encode(result) {
                                UserDefaults.standard.set(data, forKey: Constants.downloadBooksKey)
                                
                                ContentMediator.shared.notifyAboutRemovedDownload(bookId: bookId)
                            }
                        }
                        
                        event(.success(Void()))
                        
                        return Disposables.create()
                    }
            }
    }
    
    func obtainChallenge(id: Int) -> Single<Challenge?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetChallengeRequest(userToken: userToken, challengeId: id)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetChallengeResponse.map(from: $0) }
    }
}

// MARK: Private
private extension ContentManager {
    func loadCategories() -> Single<[Category]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCategoriesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCategoriesResponse.map(from: $0) }
            .do(onSuccess: { categories in
                guard let data = try? JSONEncoder().encode(categories) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.categoriesKey)
            })
    }
    
    func cachedCategories() -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.categoriesKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let categories = try? JSONDecoder().decode([Category].self, from: data)
                
                event(.success(categories ?? []))
                
                return Disposables.create()
            }
    }
    
    func loadRankings() -> Single<[Ranking]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetRankingRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetRankingResponse.map(from: $0) }
            .do(onSuccess: { rankings in
                guard let data = try? JSONEncoder().encode(rankings) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.rankingKey)
            })
    }
    
    func cachedRankings() -> Single<[Ranking]> {
        Single<[Ranking]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.rankingKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let rankings = try? JSONDecoder().decode([Ranking].self, from: data)
                
                event(.success(rankings ?? []))
                
                return Disposables.create()
            }
    }
}
