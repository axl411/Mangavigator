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
        os_log("cacheURL: %s", cacheURL.absoluteString)
        return cacheURL
    }()

    private static func configuredBookCacheDirURL(forBookURL bookURL: URL) throws -> URL {
        let dirName = (bookURL.deletingPathExtension().path as NSString).lastPathComponent
        let dirURL = cacheURL.appendingPathComponent(dirName, isDirectory: true)
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
        os_log("dirURL: %s", dirURL.absoluteString)
        return dirURL
    }

    static func bookPageURL(forBookURL bookURL: URL, bookPageFileName: String) throws -> URL {
        let dirURL = try configuredBookCacheDirURL(forBookURL: bookURL)
        let bookPageURL = dirURL.appendingPathComponent(bookPageFileName, isDirectory: false)
        os_log("bookPageURL: %s", bookPageURL.absoluteString)
        return bookPageURL
    }
}
