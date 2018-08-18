//
//  BookData.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/18.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import ZIPFoundation

class BookData {
    let archive: Archive
    let entries: [Entry]

    init(fileURL: URL) throws {
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive
        entries = archive.compactMap { (entry: Entry) -> Entry? in
            guard entry.isWantedFile else { return nil }
            return entry
        }.sorted { $0.fileName < $1.fileName }
    }
}
