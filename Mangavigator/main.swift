//
//  main.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/03.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

autoreleasepool {
    // Even if we loading application manually we need to setup `Info.plist` key:
    // <key>NSPrincipalClass</key>
    // <string>NSApplication</string>
    // Otherwise Application will be loaded in `low resolution` mode.
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.setActivationPolicy(.regular)
    app.run()
}
