//
//  UserDefaults+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/01.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation

private let userDefaults = UserDefaults.standard

extension UserDefaults {
    private static let bookDirectionKey = "bookDirection"
    static func bookDirection() -> BookDirection {
        let result = userDefaults.integer(forKey: bookDirectionKey)
        return BookDirection(rawValue: result) ?? .leftToRight
    }
    static func setBookDirection(_ direction: BookDirection) {
        userDefaults.set(direction.rawValue, forKey: bookDirectionKey)
        userDefaults.synchronize()
    }

    private static let bookLayoutModeKey = "bookLayoutMode"
    static func bookLayoutMode() -> BookLayoutMode {
        let result = userDefaults.integer(forKey: bookLayoutModeKey)
        return BookLayoutMode(rawValue: result) ?? .singlePage
    }
    static func setBookLayoutMode(_ layoutMode: BookLayoutMode) {
        userDefaults.set(layoutMode.rawValue, forKey: bookLayoutModeKey)
        userDefaults.synchronize()
    }
}
