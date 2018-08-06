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

    init(fileURL: URL) throws {
        self.fileURL = fileURL
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive
    }

    func firstPage() throws -> BookPage? {
        guard let firstEntry = archive.first(where: { $0.type == .file }) else { return nil }
        let fileName = (firstEntry.path as NSString).lastPathComponent
        let bookPageURL = try FileManager.bookPageURL(forBookURL: fileURL, bookPageFileName: fileName)

        if !FileManager.default.fileExists(atPath: bookPageURL.path) {
            try _ = archive.extract(firstEntry, to: bookPageURL)
        }

        if let image = NSImage(contentsOf: bookPageURL) {
            return .image(image)
        } else {
            return .nonImage
        }
    }
}
