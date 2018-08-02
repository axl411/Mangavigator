//
//  Book.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import ZIPFoundation
import CryptoSwift

class Book {
    private let fileURL: URL
    private let archive: Archive

    init(fileURL: URL) throws {
        self.fileURL = fileURL
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive
        if let data = try? Data(contentsOf: fileURL) {
            let md5 = data.md5().toHexString()
            print(md5)
            // TODO: look into getting file fingerprint quickly
        }
    }
}
