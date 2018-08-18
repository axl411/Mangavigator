//
//  Book.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import os
import ZIPFoundation

private let log = LogCategory.model.log()

class Book: NSObject {
    private let fileURL: URL
    private let archive: Archive
    private let entries: [Entry]
    @objc dynamic private(set) var currentIndex = 0

    init(fileURL: URL) throws {
        self.fileURL = fileURL
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive
        entries = archive.compactMap { (entry: Entry) -> Entry? in
            guard entry.isWantedFile else { return nil }
            return entry
        }.sorted { $0.fileName < $1.fileName }
    }

    func currentPage() throws -> BookPage? {
        return try pageAtIndex(currentIndex)
    }

    func goToPreviousPage() {
        guard currentIndex > entries.startIndex else { return }
        currentIndex -= 1
        os_log("GoToPreviousPage: %d", log: log, currentIndex)
    }

    func goToNextPage() {
        guard currentIndex < entries.endIndex - 1 else { return }
        currentIndex += 1
        os_log("goToNextPage: %d", log: log, currentIndex)
    }

    private func pageAtIndex(_ index: Int) throws -> BookPage {
        let entry = entries[index]

        var imageData = Data()
        try _ = archive.extract(entry) { data in
            imageData.append(data)
        }
        if let image = NSImage(data: imageData) {
            return .image(image)
        } else {
            return .nonImage
        }
    }
}
