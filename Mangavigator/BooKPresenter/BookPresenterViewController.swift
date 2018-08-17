//
//  BookPresenterController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/07/31.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa
import ZIPFoundation
import os

private let log = LogCategory.userInterface.log()

class BookPresenterViewController: NSViewController {
    private let book: Book
    private let imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()
    private var observing: NSKeyValueObservation?

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let keyboardView = KeyboardView()
        view = keyboardView
        keyboardView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true

        view.addSubview(imageView)

        observing = book.observe(\.currentIndex, options: [.initial, .new]) { [book, imageView] (_, _) in
            do {
                guard let currentPage = try book.currentPage() else { return }
                if case .image(let image) = currentPage {
                    imageView.image = image
                }
            } catch {
                os_log("%@", log: log, type: .error, error.localizedDescription)
            }
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        imageView.frame = view.bounds
    }
}

extension BookPresenterViewController: KeyboardViewDelegate {
    func rightPressed() {
        book.goToNextPage()
    }

    func leftPressed() {
        book.goToPreviousPage()
    }
}
