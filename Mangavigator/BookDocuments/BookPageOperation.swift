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

    init(targetIndex: Int, bookData: BookData) {
        super.init()
        addExecutionBlock { [unowned self] in
            let entry = bookData.entries[targetIndex]

            var imageData = Data()
            try? _ = bookData.archive.extract(entry) { data in
                imageData.append(data)
            }
            if let image = NSImage(data: imageData) {
                self.bookPage = .image(image)
            } else {
                self.bookPage = .nonImage
            }
        }
    }
}
