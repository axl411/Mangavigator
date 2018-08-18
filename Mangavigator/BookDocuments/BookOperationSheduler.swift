//
//  BookOperationSheduler.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation

class BookOperationSheduler {
    private let queue = OperationQueue()
    private let bookData: BookData

    init(bookData: BookData) {
        self.bookData = bookData
    }

    func bookPage(forTargetIndex index: Int) -> BookPage {
        let operation = BookPageOperation(targetIndex: index, bookData: bookData)
        queue.addOperations([operation], waitUntilFinished: true)
        return operation.bookPage!
    }
}
