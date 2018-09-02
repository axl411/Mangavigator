//
//  AppDelegate.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/17.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        setupMenus()
    }

    @objc private func quit() {
        NSApp.terminate(self)
    }

}
