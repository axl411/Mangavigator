//
//  Entry+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/12.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import ZIPFoundation

extension Entry {
    var fileName: String {
        return (path as NSString).lastPathComponent
    }

    var isWantedFile: Bool {
        guard type == .file else { return false }
        // wanted: 09df85467392381dd134565f757e2511/19.jpg
        // unwanted: __MACOSX/09df85467392381dd134565f757e2511/._19.jpg
        // unwanted: __MACOSX/._09df85467392381dd134565f757e2511
        return !fileName.hasPrefix(".")
    }
}
