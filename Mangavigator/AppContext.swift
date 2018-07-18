//
//  AppContext.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/17.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

struct AppContext {
    let mainWindow: NSWindow
    
    init(mainWindow: NSWindow) {
        mainWindow.titleVisibility = NSWindow.TitleVisibility.hidden
        mainWindow.titlebarAppearsTransparent = true
        mainWindow.styleMask = [NSWindow.StyleMask.fullSizeContentView, mainWindow.styleMask]
        mainWindow.setFrame(NSScreen.main!.frame.insetBy(dx: 100, dy: 100), display: true)
        self.mainWindow = mainWindow
    }
}
