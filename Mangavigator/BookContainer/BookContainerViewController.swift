//
//  BookContainerViewController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/28.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

class BookContainerViewController: NSViewController {
    private let book: Book
    private lazy var bookShelfViewController = BookShelfViewController()
    private lazy var bookPresenterViewController = BookPresenterViewController(book: book)

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.yellow.cgColor

        addChild(bookShelfViewController)
        view.addSubview(bookShelfViewController.view)

        addChild(bookPresenterViewController)
        view.addSubview(bookPresenterViewController.view)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        bookShelfViewController.view.frame = NSRect(
            x: 0,
            y: 0,
            width: view.frame.width * 0.3,
            height: view.frame.height
        )

        bookPresenterViewController.view.frame = view.bounds
    }
}
