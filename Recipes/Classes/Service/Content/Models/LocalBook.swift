//
//  LocalBook.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import Foundation

struct LocalBook: Codable, Hashable {
    let original: Book
    let audioLocalURL: AudioLocalURL
    
    init(original: Book, audioLocalURL: AudioLocalURL) {
        self.original = original
        self.audioLocalURL = audioLocalURL
    }
    
    // копия оригинального объекта, но с урл на локальный загруженный файл
    func combine() -> Book {
        let fileUrl = FileManager.default
            .urls(for: audioLocalURL.directory, in: audioLocalURL.domainMask)[0]
            .appendingPathComponent(audioLocalURL.fileName)
        
        return Book(id: original.id,
                    name: original.name,
                    imageUrl: original.imageUrl,
                    author: original.author,
                    rankingId: original.rankingId,
                    time: original.time,
                    audioUrl: fileUrl,
                    shareLink: original.shareLink,
                    isSaved: original.isSaved,
                    introduction: original.introduction,
                    chapters: original.chapters,
                    whatAbout: original.whatAbout)
    }
}

struct AudioLocalURL: Codable, Hashable {
    let fileName: String
    let directory: FileManager.SearchPathDirectory
    let domainMask: FileManager.SearchPathDomainMask
}

extension FileManager.SearchPathDirectory: Codable, Hashable {}
extension FileManager.SearchPathDomainMask: Codable, Hashable {}
