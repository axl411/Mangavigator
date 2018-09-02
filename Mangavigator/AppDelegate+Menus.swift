//
//  AppDelegate+Menus.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/03.
//  Copyright © 2018 Gu Chao. All rights reserved.
//
// https://stackoverflow.com/questions/3436395/how-i-can-get-the-application-menu-in-cocoa/33581939#33581939

import Cocoa

extension AppDelegate {
    func setupMenus() {
        NSApp.mainMenu = NSMenu(title: "Title doesn't matter")

        setupAppMenu()
        setupFileMenu()
        setupViewMenu()
        // TODO: delete storyboard after finish all menu items
    }

    private func setupAppMenu() {
        let mainAppMenuItem = NSMenuItem(title: "Title doesn't matter", action: nil, keyEquivalent: "")
        NSApp.mainMenu?.addItem(mainAppMenuItem)

        let appMenu = NSMenu(title: "Title doesn't matter")
        mainAppMenuItem.submenu = appMenu

        let appServicesMenu = NSMenu()
        NSApp.servicesMenu = appServicesMenu

        appMenu.addItem(withTitle: "About", action: nil, keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Preferences...", action: nil, keyEquivalent: ",")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(
            withTitle: "Hide \(Bundle.main.bundleName!)",
            action: #selector(NSApplication.hide(_:)),
            keyEquivalent: "h"
        )
        appMenu.addItem({ () -> NSMenuItem in
            let m = NSMenuItem(
                title: "Hide Others",
                action: #selector(NSApplication.hideOtherApplications(_:)),
                keyEquivalent: "h"
            )
            m.keyEquivalentModifierMask = [.command, .option]
            return m
        }())
        appMenu.addItem(
            withTitle: "Show All",
            action: #selector(NSApplication.unhideAllApplications(_:)),
            keyEquivalent: ""
        )

        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Services", action: nil, keyEquivalent: "").submenu = appServicesMenu
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    }

    private func setupFileMenu() {
        let mainFileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        NSApp.mainMenu?.addItem(mainFileMenuItem)

        let fileMenu = NSMenu(title: "File")
        mainFileMenuItem.submenu = fileMenu
        fileMenu.addItem(
            withTitle: "Open...",
            action: #selector(NSDocumentController.openDocument(_:)),
            keyEquivalent: "o"
        )

        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(
            withTitle: "Close",
            action: #selector(NSWindow.performClose(_:)),
            keyEquivalent: "w"
        )
    }

    private func setupViewMenu() {
        let mainViewMenuItem = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
        NSApp.mainMenu?.addItem(mainViewMenuItem)

        let viewMenu = NSMenu(title: "View")
        mainViewMenuItem.submenu = viewMenu
        viewMenu.addItem({ () -> NSMenuItem in
            let fullScreenItem = NSMenuItem(
                title: "Enter Full Screen",
                action: #selector(NSWindow.toggleFullScreen(_:)),
                keyEquivalent: "f"
            )
            fullScreenItem.keyEquivalentModifierMask = [.command, .control]
            return fullScreenItem
        }())
    }
}
