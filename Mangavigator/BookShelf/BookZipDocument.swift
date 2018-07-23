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
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("BookWindowViewController")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print(url)
    }
}

