//
//  BookControlsViewController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/28.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

private let nameLabelInset: CGFloat = 40

class BookControlsViewController: NSViewController {
    private let book: Book
    private let textField: NSTextField = {
        let textField = NSTextField()
        textField.alignment = .center
        textField.font = NSFont.labelFont(ofSize: 20)
        textField.backgroundColor = NSColor(white: 0, alpha: 0.6)
        textField.textColor = NSColor(white: 1, alpha: 1)
        textField.isEditable = false
        textField.isBezeled = false
        textField.isSelectable = false
        return textField
    }()

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.stringValue = book.name
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: nameLabelInset),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // TODO: auto hide book title
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        textField.preferredMaxLayoutWidth = view.frame.width - nameLabelInset * 2
    }
}
