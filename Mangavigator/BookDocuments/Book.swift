//
//  Book.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os
import ZIPFoundation

class Book {
    private let fileURL: URL
    private let archive: Archive
    private let entries: [Entry]
    private var currentIndex = 0

    init(fileURL: URL) throws {
        self.fileURL = fileURL
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive
        entries = archive.compactMap { (entry: Entry) -> Entry? in
            guard entry.type == .file else { return nil }
            return entry
        }
    }

    func currentPage() throws -> BookPage? {
        return try pageAtIndex(currentIndex)
    }

    func previousPage() throws -> BookPage? {
        guard currentIndex > entries.startIndex else { return nil }
        let page = try pageAtIndex(currentIndex - 1)
        currentIndex += 1
        return page
    }

    func nextPage() throws -> BookPage? {
        guard currentIndex < entries.endIndex - 1 else { return nil }
        let page = try pageAtIndex(currentIndex + 1)
        currentIndex += 1
        return page
    }

    private func pageAtIndex(_ index: Int) throws -> BookPage {
        let entry = entries[index]
        let bookPageURL = try FileManager.bookPageURL(forBookURL: fileURL, bookPageFileName: entry.fileName)

        if !FileManager.default.fileExists(atPath: bookPageURL.path) {
            try _ = archive.extract(entry, to: bookPageURL)
        }

        if let image = NSImage(contentsOf: bookPageURL) {
            return .image(image)
        } else {
            return .nonImage
        }
    }
}
