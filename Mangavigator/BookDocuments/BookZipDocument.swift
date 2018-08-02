//
//  BookZip.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/23.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

class BookZipDocument: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        guard let fileURL = fileURL else { return }
        let archive = try! Book(fileURL: fileURL)
        let containerViewController = BookContainerViewController(file: fileURL)
        let newWindow = NSWindow(contentViewController: containerViewController)
        let windowController = NSWindowController(window: newWindow)
        newWindow.titleVisibility = NSWindow.TitleVisibility.hidden
        newWindow.titlebarAppearsTransparent = true
        newWindow.styleMask = [NSWindow.StyleMask.fullSizeContentView, newWindow.styleMask]
        newWindow.setFrame(NSScreen.main!.frame.insetBy(dx: 100, dy: 100), display: true)
        addWindowController(windowController)
    }

    override func read(from url: URL, ofType typeName: String) throws {
//        fileURL = url
    }
}
