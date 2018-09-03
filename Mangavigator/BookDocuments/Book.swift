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
    private lazy var operationScheduler = BookOperationScheduler(bookData: bookData)
    @objc dynamic private(set) var currentIndex = 0

    init(fileURL: URL) throws {
        bookData = try BookData(fileURL: fileURL)
    }

    func toggleMode() {
        mode = mode.toggled()
        UserDefaults.setBookLayoutMode(mode)
    }

    func page(for intent: BookNaviIntent) throws -> BookPage {
        return operationScheduler.process(intent)
    }

    func peekNextPage() throws -> BookPage? {
        guard currentIndex < bookData.entries.endIndex - 1 else { return nil }
        return try page(for: intent(
            targetIndex: .specific(currentIndex + 1),
            isGoingForward: true,
            needsPreloading: false
        ))
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

    func isValidIndex(_ index: Int) -> Bool {
        return (bookData.entries.startIndex..<bookData.entries.endIndex).contains(index)
    }
}

extension Book {
    var name: String {
        return bookData.archive.url.lastPathComponent
    }
}

extension Book {
    func intent(
        targetIndex: BookNaviIntent.TargetIndex,
        isGoingForward: Bool,
        needsPreloading: Bool = true
    ) throws -> BookNaviIntent {
        return try BookNaviIntent(
            book: self,
            targetIndex: targetIndex,
            isGoingForward: isGoingForward,
            needsPreloading: needsPreloading
        )
    }
}

struct BookNaviIntent {

    enum TargetIndex {
        case current
        case specific(Int)
    }

    enum Error: Swift.Error {
        case invalidIndex(Int)
    }

    let book: Book
    private let targetIndex: TargetIndex
    let isGoingForward: Bool
    let needsPreloading: Bool

    /// this index is guaranteed to be valid
    var index: Int {
        switch targetIndex {
        case .current: return book.currentIndex
        case .specific(let idx): return idx
        }
    }

    fileprivate init(book: Book, targetIndex: TargetIndex, isGoingForward: Bool, needsPreloading: Bool) throws {
        self.book = book
        self.targetIndex = targetIndex
        self.isGoingForward = isGoingForward
        self.needsPreloading = needsPreloading

        guard book.isValidIndex(index) else { throw Error.invalidIndex(index) }
    }
}
