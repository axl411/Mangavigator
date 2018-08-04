//
//  Book.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os
import ZIPFoundation

class Book {
    private let fileURL: URL
    private let archive: Archive

    init(fileURL: URL) throws {
        self.fileURL = fileURL
        guard let archive = Archive(url: fileURL, accessMode: .read) else { throw BookError.failedAccessingArchive }
        self.archive = archive

        do {
            let cacheURL = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            os_log("cache URL: %s", cacheURL.absoluteString)

            let dirName = (self.fileURL.deletingPathExtension().path as NSString).lastPathComponent
            let dirURL = cacheURL.appendingPathComponent(dirName, isDirectory: true)
            var isDir: ObjCBool = true
            if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) || !isDir.boolValue {
                try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
            }

            let firstEntry = archive.first { entry in
                entry.type == .file
            }!
            let fileName = (firstEntry.path as NSString).lastPathComponent
            let fileURL = dirURL.appendingPathComponent(fileName, isDirectory: false)
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try archive.extract(firstEntry, to: fileURL)
            }

        }
        catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
