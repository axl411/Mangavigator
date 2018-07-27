//
//  BookShelfItem.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/22.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

final class BookItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier("BookItem")

    override func loadView() {
        // CocoaPitfalls: overriding of this and manually creating a view is needed
        // or else the method will try to load the view from a nib in main bundle
        // and somehow the bundle is nil. The exception is like
        // '-[NSNib _initWithNibNamed:bundle:options:] could not load the nibName:
        // Mangavigator.BookItem in bundle (null).'
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
    }
}
