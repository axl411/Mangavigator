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

class Book: NSObject {
    private let bookData: BookData
    private lazy var operationSheduler = BookOperationSheduler(bookData: bookData)
    @objc dynamic private(set) var currentIndex = 0

    init(fileURL: URL) throws {
        bookData = try BookData(fileURL: fileURL)
    }

    func currentPage() throws -> BookPage? {
        return try pageAtIndex(currentIndex)
    }

    func goToPreviousPage() {
        guard currentIndex > bookData.entries.startIndex else { return }
        currentIndex -= 1
        os_log("GoToPreviousPage: %d", log: log, currentIndex)
    }

    func goToNextPage() {
        guard currentIndex < bookData.entries.endIndex - 1 else { return }
        currentIndex += 1
        os_log("goToNextPage: %d", log: log, currentIndex)
    }

    private func pageAtIndex(_ index: Int) throws -> BookPage {
        return operationSheduler.bookPage(forTargetIndex: index)
    }
}
