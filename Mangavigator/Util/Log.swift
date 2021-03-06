//
//  Log.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/14.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import os

enum LogCategory: String {
    case userInterface
    case model
    case concurrency

    func log() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: rawValue)
    }
}
