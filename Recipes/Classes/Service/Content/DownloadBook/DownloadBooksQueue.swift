//
//  DownloadBooksQueue.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

final class DownloadBooksQueue {
    static let shared = DownloadBooksQueue()
    
    private init() {}
    
    var operations = [Int: DownloadBookOperation]()
}

// MARK: Public
extension DownloadBooksQueue {
    func download(book: Book, delegate: DownloadBookDelegate?, completion: @escaping ((LocalBook?) -> Void)) {
        let key = book.id
        
        let operation = DownloadBookOperation(book: book)
        operation.delegate = delegate
        operations[key] = operation
        
        operation.download { [weak self] result in
            self?.operations.removeValue(forKey: key)
            
            completion(result)
        }
    }
    
    func removeOperation(for bookId: Int) {
        operations[bookId]?.stop()
        operations.removeValue(forKey: bookId)
    }
    
    func subscribe(book id: Int, on delegate: DownloadBookDelegate) {
        operations.first(where: { $0.key == id })?.value.delegate = delegate
    }
    
    func containsOperation(with bookId: Int) -> Bool {
        operations.contains(where: { $0.key == bookId })
    }
}
