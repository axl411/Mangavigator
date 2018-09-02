//
//  BookPageOperation.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import ZIPFoundation

class BookPageOperation: BlockOperation {
    var bookPage: BookPage?
    let targetIndex: Int

    init(targetIndex: Int, bookData: BookData) {
        self.targetIndex = targetIndex
        super.init()
        name = bookData.operationName(forIndex: targetIndex)
        addExecutionBlock { [weak self] in
            guard let self = `self` else { return }
            let entry = bookData.entries[targetIndex]

            var imageData = Data()
            try? _ = bookData.archive.extract(entry) { data in
                imageData.append(data)
            }
            if let image = NSImage(data: imageData) {
                self.bookPage = .image(image)
            } else {
                self.bookPage = .nonImage(fileName: entry.fileName)
            }
        }
    }
}

extension BookPageOperation {
    func addToQueue(_ queue: OperationQueue, onFinish: @escaping () -> Void) {
        let doneOperation = BlockOperation(block: onFinish)
        doneOperation.addDependency(self)
        queue.addOperations([self, doneOperation], waitUntilFinished: false)
    }
}

extension BookData {
    func operationName(forIndex index: Int) -> String {
        return self[index].path
    }
}
