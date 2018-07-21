//
//  AppDelegate.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/17.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let appContext = AppContext(mainWindow: NSApp.mainWindow!)
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}
