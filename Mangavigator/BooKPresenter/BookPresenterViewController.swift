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
    private var observing: NSKeyValueObservation?

    private lazy var bookControlsViewController = BookControlsViewController(book: book)

    private let imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let keyboardView = EventsView()
        view = keyboardView
        view.wantsLayer = true
        keyboardView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        addChildViewController(bookControlsViewController, childViewLayout: .fill)
        bookControlsViewController.view.isHidden = true
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        imageView.frame = view.bounds
    }

    @objc private func hideControls() {
        bookControlsViewController.view.animator().isHidden = true
    }
}

extension BookPresenterViewController: EventsViewDelegate {
    func mouseMoved() {
        if bookControlsViewController.view.isHidden {
            bookControlsViewController.view.animator().isHidden = false
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideControls), object: nil)
        }
        perform(#selector(hideControls), with: nil, afterDelay: 1.5)
    }

    func rightPressed() {
        book.goToNextPage()
    }

    func leftPressed() {
        book.goToPreviousPage()
    }
}
