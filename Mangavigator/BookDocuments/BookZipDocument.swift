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
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let windowController = storyboard.instantiateController(
            withIdentifier: NSStoryboard.SceneIdentifier("BookContainer")
        ) as? NSWindowController,
            let newWindow = windowController.window
        else { return }
        newWindow.titleVisibility = NSWindow.TitleVisibility.hidden
        newWindow.titlebarAppearsTransparent = true
        newWindow.styleMask = [NSWindow.StyleMask.fullSizeContentView, newWindow.styleMask]
        newWindow.setFrame(NSScreen.main!.frame.insetBy(dx: 100, dy: 100), display: true)
        addWindowController(windowController)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print(url)
    }
}

