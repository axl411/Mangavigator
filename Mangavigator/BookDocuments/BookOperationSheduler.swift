//
//  BookOperationSheduler.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation

class BookOperationSheduler {
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    private let bookData: BookData
    private var preloadedOperations = [BookPageOperation]()
    private let preloadedOperationsLock = NSLock()

    init(bookData: BookData) {
        self.bookData = bookData
    }

    func bookPage(forTargetIndex index: Int) -> BookPage {
        let operation = sheduledOperation(forTargetIndex: index)
        operation.waitUntilFinished()
        addLoadedOperation(operation)
        shedulePreloadingOperation(forCurrentIndex: index)
        return operation.bookPage!
    }

    private func sheduledOperation(forTargetIndex index: Int) -> BookPageOperation {
        if let operation = findOperation(forTargetIndex: index) {
            return operation
        } else {
            let newOperation = BookPageOperation(targetIndex: index, bookData: bookData)
            queue.addOperation(newOperation)
            return newOperation
        }
    }

    private func findOperation(forTargetIndex index: Int) -> BookPageOperation? {
        preloadedOperationsLock.lock()
        defer {
            preloadedOperationsLock.unlock()
        }
        if let operation = preloadedOperations.first(where: { $0.name == bookData.operationName(forIndex: index)}) {
            return operation
        } else {
            return queue.operations.first(
                where: { $0.name == bookData.operationName(forIndex: index)}
            ) as? BookPageOperation
        }
    }

    private func shedulePreloadingOperation(forCurrentIndex index: Int) {
        shedulePreloadingOperationForImage(atIndex: index + 1)
        shedulePreloadingOperationForImage(atIndex: index + 2)
    }

    private func shedulePreloadingOperationForImage(atIndex indexToPreload: Int) {
        guard bookData.entries.startIndex..<bookData.entries.endIndex ~= indexToPreload,
            findOperation(forTargetIndex: indexToPreload) == nil
            else { return }
        let operation = BookPageOperation(targetIndex: indexToPreload, bookData: bookData)

        operation.addToQueue(queue) {
            self.addLoadedOperation(operation)
        }
    }

    private func addLoadedOperation(_ operation: BookPageOperation) {
        preloadedOperationsLock.lock()
        defer {
            preloadedOperationsLock.unlock()
        }
        guard operation.isFinished else { assertionFailure(); return }
        preloadedOperations.removeAll(where: { $0.name == operation.name })
        preloadedOperations.append(operation)
        if preloadedOperations.count > 5 {
            preloadedOperations.remove(at: preloadedOperations.startIndex)
        }
    }
}
