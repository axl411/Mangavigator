//
//  BookError.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation

enum BookError: Error {
    case failedAccessingArchive
    case failedGeneratingSHA1ForPath(String)
}
