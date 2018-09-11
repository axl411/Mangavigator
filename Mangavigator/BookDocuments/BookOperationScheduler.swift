//
//  BookOperationScheduler.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os

private let log = LogCategory.concurrency.log()
private let preloadedForwardOpCount = 5 // this includes the op for the current book index
private let preloadedBackwardOpCount = 2

class BookOperationScheduler {

    private enum OpFoundType: String {
        case foundPreloaded = "✅"
        case foundOnGoing = "▶️"
        case notFound = "❌"
    }

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

    func process(_ intent: BookNaviIntent) -> BookPage {
        os_log("ℹ️ Finding bookPage for index %d", log: log, type: .debug, intent.index)
        let operation = scheduledOperation(forTargetIndex: intent.index)
        operation.waitUntilFinished()
        schedulePreloadingOperations(for: intent)
        return operation.bookPage!
    }

    private func scheduledOperation(forTargetIndex index: Int) -> BookPageOperation {
        let (op, type) = findOperation(forTargetIndex: index)
        if let op = op {
            os_log("%@ Found preloaded or running op[%d]", log: log, type: .debug, type.rawValue, index)
            return op
        } else {
            os_log("%@ op[%d] not found, creat new", log: log, type: .debug, type.rawValue, index)
            let newOperation = BookPageOperation(targetIndex: index, bookData: bookData)
            newOperation.addToQueue(queue) {
                self.addLoadedOperation(newOperation, currentBookIndex: index)
            }
            return newOperation
        }
    }

    private func findOperation(forTargetIndex index: Int) -> (op: BookPageOperation?, type: OpFoundType) {
        preloadedOperationsLock.lock()
        defer {
            preloadedOperationsLock.unlock()
        }
        if let operation = preloadedOperations.first(where: { $0.name == bookData.operationName(forIndex: index)}) {
            return (op: operation, type: .foundPreloaded)
        } else {
            if let operation = queue.operations.first(
                where: { $0.name == bookData.operationName(forIndex: index)}
            ) as? BookPageOperation {
                return (op: operation, type: .foundOnGoing)
            } else {
                return (op: nil, type: .notFound)
            }
        }
    }

    private func schedulePreloadingOperations(for intent: BookNaviIntent) {
        guard intent.needsPreloading else { return }
        os_log(
            "Schedule preloading for op[%d]", log: log, type: .debug, intent.index)
        if intent.isGoingForward {
            (1...preloadedForwardOpCount).forEach {
                schedulePreloadingForImage(atIndex: intent.index + $0, intent: intent)
            }
        } else {
            (1...preloadedBackwardOpCount).forEach {
                schedulePreloadingForImage(atIndex: intent.index - $0, intent: intent)
            }
        }
    }

    /// `indexToPreload` doesn't have to be valid, it will be checked
    private func schedulePreloadingForImage(atIndex indexToPreload: Int, intent: BookNaviIntent) {
        guard bookData.entries.startIndex..<bookData.entries.endIndex ~= indexToPreload,
            findOperation(forTargetIndex: indexToPreload).type == .notFound
            else { return }
        let operation = BookPageOperation(targetIndex: indexToPreload, bookData: bookData)

        os_log("Preload op[%d]", log: log, type: .debug, indexToPreload)
        operation.addToQueue(queue) {
            self.addLoadedOperation(operation, currentBookIndex: intent.index)
        }
    }
// TODO: add recents in "File" menu
    private func addLoadedOperation(_ operation: BookPageOperation, currentBookIndex: Int) {
        preloadedOperationsLock.lock()
        defer {
            preloadedOperationsLock.unlock()
        }
        guard operation.isFinished else { assertionFailure(); return }
        guard !preloadedOperations.contains(where: { operation.name == $0.name }) else { return }

        preloadedOperations.append(operation)
        preloadedOperations.sort { $0.targetIndex < $1.targetIndex }

        if let currentIndex = preloadedOperations.firstIndex(where: { $0.targetIndex == currentBookIndex }) {
            let lowerBound = max(preloadedOperations.startIndex, currentIndex - preloadedBackwardOpCount)
            print("lower: \(lowerBound)")
            let upperBound = min(preloadedOperations.endIndex, currentIndex + preloadedForwardOpCount)
            print("upper: \(upperBound)")
            preloadedOperations = Array(preloadedOperations[lowerBound..<upperBound])
        }

        os_log(
            "Finished ops: %@",
            log: log,
            type: .debug,
            preloadedOperations.reduce(into: "") { (result, op) in
                if !result.isEmpty {
                    result += " > "
                }
                result += op.targetIndex == currentBookIndex ? "[\(currentBookIndex)]" : "\(op.targetIndex)"
            }
        )
    }
}
