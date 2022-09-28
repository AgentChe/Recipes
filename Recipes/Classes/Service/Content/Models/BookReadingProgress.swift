//
//  BookReadingProgress.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

struct BookReadingProgress: Codable, Hashable {
    let book: Book
    let currentChapterIndex: Int
}

// MARK: Public
extension BookReadingProgress {
    var progress: Float {
        guard !book.chapters.isEmpty else {
            return 0
        }
        
        let number = (currentChapterIndex + 1)
        return Float(number) / Float(book.chapters.count)
    }
}
