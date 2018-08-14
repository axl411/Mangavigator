//
//  String+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/14.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    func sha1() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
