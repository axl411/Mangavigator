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
// TODO: optimize preloading: when going backward, should preload backward
private let preloadedOperationCount = 6

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
        addLoadedOperation(operation)
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
            queue.addOperation(newOperation)
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
            (1...preloadedOperationCount - 2).forEach { schedulePreloadingForImage(atIndex: intent.index + $0) }
        } else {
            [-1, -2].forEach { schedulePreloadingForImage(atIndex: intent.index + $0) }
        }
    }

    /// `indexToPreload` doesn't have to be valid, it will be checked
    private func schedulePreloadingForImage(atIndex indexToPreload: Int) {
        guard bookData.entries.startIndex..<bookData.entries.endIndex ~= indexToPreload,
            findOperation(forTargetIndex: indexToPreload).type == .notFound
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
