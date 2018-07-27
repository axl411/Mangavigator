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

        NSWindow.allowsAutomaticWindowTabbing = false
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }

}

// TODO: add a navigation side bar to MangaPage
