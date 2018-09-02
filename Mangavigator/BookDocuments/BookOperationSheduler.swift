//
//  BookOperationSheduler.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os

private let log = LogCategory.concurrency.log()

private let preloadedOperationCount = 6

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
        os_log("ℹ️ Finding bookPage for index %d", log: log, type: .debug, index)
        let operation = sheduledOperation(forTargetIndex: index)
        operation.waitUntilFinished()
        addLoadedOperation(operation)
        shedulePreloadingOperation(forCurrentIndex: index)
        return operation.bookPage!
    }

    private func sheduledOperation(forTargetIndex index: Int) -> BookPageOperation {
        if let operation = findOperation(forTargetIndex: index) {
            os_log("✅ Found preloaded or running op[%d]", log: log, type: .debug, index)
            return operation
        } else {
            os_log("❌ op[%d] not found, creat new", log: log, type: .debug, index)
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
            os_log("Found finished op[%d]", log: log, type: .debug, index)
            return operation
        } else {
            if let operation = queue.operations.first(
                where: { $0.name == bookData.operationName(forIndex: index)}
            ) as? BookPageOperation {
                os_log("Found running op[%d]", log: log, type: .debug, index)
                return operation
            } else {
                return nil
            }
        }
    }

    private func shedulePreloadingOperation(forCurrentIndex index: Int) {
        os_log(
            "Shedule preloading for op[%d]", log: log, type: .debug, index)
        (1...preloadedOperationCount - 2).forEach { shedulePreloadingOperationForImage(atIndex: index + $0) }
    }

    private func shedulePreloadingOperationForImage(atIndex indexToPreload: Int) {
        guard bookData.entries.startIndex..<bookData.entries.endIndex ~= indexToPreload,
            findOperation(forTargetIndex: indexToPreload) == nil
            else { return }
        let operation = BookPageOperation(targetIndex: indexToPreload, bookData: bookData)

        os_log("Preload op[%d]", log: log, type: .debug, indexToPreload)
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
        guard !preloadedOperations.contains(where: { operation.name == $0.name }) else { return }
        preloadedOperations.removeAll(where: { $0.name == operation.name })
        preloadedOperations.append(operation)
        if preloadedOperations.count > preloadedOperationCount {
            preloadedOperations.remove(at: preloadedOperations.startIndex)
        }
        os_log(
            "Finished ops: %@",
            log: log,
            type: .debug,
            preloadedOperations.reduce(into: "") { (result, op) in
                if !result.isEmpty {
                    result += " > "
                }
                result += String(op.targetIndex)
            }
        )
    }
}
