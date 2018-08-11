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
}
