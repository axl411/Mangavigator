//
//  Bundle+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/03.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation

extension Bundle {
    var bundleName: String? {
        return infoDictionary?[kCFBundleNameKey as String] as? String
    }
}
