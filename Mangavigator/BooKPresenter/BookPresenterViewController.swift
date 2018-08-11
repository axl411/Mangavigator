//
//  BookPresenterController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/31.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import ZIPFoundation

class BookPresenterViewController: NSViewController {
    private let book: Book
    private let imageView = NSImageView()

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = KeyboardView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.cyan.cgColor

        view.addSubview(imageView)

        do {
            guard let currentPage = try book.currentPage() else { return }
            if case .image(let image) = currentPage {
                imageView.image = image
            }
        } catch {
            print(error)
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        imageView.frame = view.bounds
    }
}
