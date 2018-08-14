//
//  FileManager+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/06.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os

extension FileManager {
    private static let cacheURL: URL = {
        let cacheURL = try! FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        os_log("cache: %s", cacheURL.path)
        return cacheURL
    }()

    private static func configuredBookCacheDirURL(forBookURL bookURL: URL) throws -> URL {
        guard let sha1 = bookURL.path.sha1() else { throw BookError.failedGeneratingSHA1ForPath(bookURL.path) }
        let bookDirName = (bookURL.deletingPathExtension().path as NSString).lastPathComponent
        let dirURL = cacheURL
            .appendingPathComponent("BookCache", isDirectory: true)
            .appendingPathComponent(sha1 + "-" + bookDirName, isDirectory: true)
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
        os_log("dir: %s", dirURL.path)
        return dirURL
    }

    static func bookPageURL(forBookURL bookURL: URL, bookPageFileName: String) throws -> URL {
        let dirURL = try configuredBookCacheDirURL(forBookURL: bookURL)
        let bookPageURL = dirURL.appendingPathComponent(bookPageFileName, isDirectory: false)
        os_log("bookPage: %s", bookPageURL.path)
        return bookPageURL
    }
}
