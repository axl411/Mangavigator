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
    // TODO: key on menu: implement -[menuDelegate menuNeedsUpdate:]
    override func makeWindowControllers() {
        guard let fileURL = fileURL else { return }
        do {
            let book = try Book(fileURL: fileURL)
            let containerViewController = BookContainerViewController(book: book)
            let newWindow = NSWindow(contentViewController: containerViewController)
            let windowController = NSWindowController(window: newWindow)
            newWindow.titleVisibility = NSWindow.TitleVisibility.hidden
            newWindow.titlebarAppearsTransparent = true
            newWindow.styleMask = [NSWindow.StyleMask.fullSizeContentView, newWindow.styleMask]
            newWindow.setFrame(NSScreen.main!.frame, display: true)
            addWindowController(windowController)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    override func read(from url: URL, ofType typeName: String) throws {
//        fileURL = url
    }
}
