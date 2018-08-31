//
//  Book.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import os

private let log = LogCategory.model.log()

@objc enum BookLayoutMode: Int {
    case singlePage = 0
    case dualPage

    func step() -> Int {
        switch self {
        case .singlePage: return 1
        case .dualPage: return 2
        }
    }

    func toggled() -> BookLayoutMode {
        switch self {
        case .singlePage: return .dualPage
        case .dualPage: return .singlePage
        }
    }
}

class Book: NSObject {
    @objc dynamic private(set) var mode = UserDefaults.bookLayoutMode()
    private let bookData: BookData
    private lazy var operationSheduler = BookOperationSheduler(bookData: bookData)
    @objc dynamic private(set) var currentIndex = 0

    init(fileURL: URL) throws {
        bookData = try BookData(fileURL: fileURL)
    }

    func toggleMode() {
        mode = mode.toggled()
        UserDefaults.setBookLayoutMode(mode)
    }

    func currentPage() throws -> BookPage? {
        return try pageAtIndex(currentIndex)
    }

    func peekNextPage() throws -> BookPage? {
        guard currentIndex < bookData.entries.endIndex - 1 else { return nil }
        return try pageAtIndex(currentIndex + 1)
    }

    func goBackward() {
        var index = currentIndex
        index -= mode.step()
        guard index >= bookData.entries.startIndex else { return }
        currentIndex = index
        os_log("goBackward: %d", log: log, currentIndex)
    }

    func goForward() {
        var index = currentIndex
        index += mode.step()
        guard index < bookData.entries.endIndex else { return }
        currentIndex = index
        os_log("goForward: %d", log: log, currentIndex)
    }

    private func pageAtIndex(_ index: Int) throws -> BookPage {
        return operationSheduler.bookPage(forTargetIndex: index)
    }
}

extension Book {
    var name: String {
        return bookData.archive.url.lastPathComponent
    }
}
