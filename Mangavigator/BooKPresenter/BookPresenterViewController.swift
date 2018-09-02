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

private let imageViewMaker: () -> NSImageView = {
    let imageView = NSImageView()
    imageView.imageAlignment = .alignCenter
    imageView.imageScaling = .scaleProportionallyUpOrDown
    return imageView
}

enum BookDirection: Int {
    case leftToRight = 0
    case rightToLeft

    func toggled() -> BookDirection {
        switch self {
        case .leftToRight: return .rightToLeft
        case .rightToLeft: return .leftToRight
        }
    }
}

class BookPresenterViewController: NSViewController {
    private let book: Book
    private var bookIndexObserving: NSKeyValueObservation?
    private var bookModeObserving: NSKeyValueObservation?

    private lazy var bookControlsViewController = BookControlsViewController(book: book)

    private let mainImageView: NSImageView = imageViewMaker()
    private let subImageView: NSImageView = imageViewMaker()

    private var direction = UserDefaults.bookDirection() {
        didSet {
            adjustImageViewFramesAndAlignments()
        }
    }

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

        view.addSubview(mainImageView)
        view.addSubview(subImageView)

        bookIndexObserving = book.observe(
            \.currentIndex,
            options: [.initial, .new]
        ) { [weak self] (_, _) in
            guard let `self` = self else { return }
            do {
                if let currentPage = try self.book.currentPage() {
                    self.setup(imageView: self.mainImageView, with: currentPage)
                }
                if self.book.mode == .dualPage {
                    try self.setupSubImageView()
                }
            } catch {
                os_log("%@", log: log, type: .error, error.localizedDescription)
            }
        }

        bookModeObserving = book.observe(
            \.mode,
            options: [.initial, .new]
        ) { [weak self] (_, _) in
            guard let `self` = self else { return }
            do {
                switch self.book.mode {
                case .singlePage: self.subImageView.isHidden = true
                case .dualPage:
                    self.subImageView.isHidden = false
                    try self.setupSubImageView()
                }
            } catch {
                os_log("%@", log: log, type: .error, error.localizedDescription)
            }
            self.adjustImageViewFramesAndAlignments()
        }

        addChildViewController(bookControlsViewController, childViewLayout: .fill)
        bookControlsViewController.view.isHidden = true
    }

    private func setupSubImageView() throws {
        if let nextPage = try book.peekNextPage() {
            setup(imageView: subImageView, with: nextPage)
        } else {
            subImageView.image = nil
        }
    }
// TODO: implement drop file on app to open
    private func setup(imageView: NSImageView, with bookPage: BookPage) {
        switch bookPage {
        case .image(let image): imageView.image = image
        case .nonImage(let fileName):
            imageView.image = Images.nonImageImage(size: mainImageView.bounds.size, fileName: "[\(fileName)]")
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        adjustImageViewFramesAndAlignments()
    }

    private func adjustImageViewFramesAndAlignments() {
        switch book.mode {
        case .singlePage:
            mainImageView.frame = view.bounds
            mainImageView.imageAlignment = .alignCenter
        case .dualPage:
            let (left, right) = view.bounds.divided(
                atDistance: view.bounds.width / 2,
                from: .minXEdge
            )
            switch direction {
            case .leftToRight:
                mainImageView.frame = left
                mainImageView.imageAlignment = .alignRight
                subImageView.frame = right
                subImageView.imageAlignment = .alignLeft
            case .rightToLeft:
                mainImageView.frame = right
                mainImageView.imageAlignment = .alignLeft
                subImageView.frame = left
                subImageView.imageAlignment = .alignRight
            }
        }
    }

    @objc private func hideControls() {
        bookControlsViewController.view.animator().isHidden = true
    }

    fileprivate func toggleDirection() {
        direction = direction.toggled()
        UserDefaults.setBookDirection(direction)
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
        switch direction {
        case .leftToRight: book.goForward()
        case .rightToLeft: book.goBackward()
        }
    }

    func leftPressed() {
        switch direction {
        case .leftToRight: book.goBackward()
        case .rightToLeft: book.goForward()
        }
    }

    func spacePressed() {
        book.toggleMode()
    }

    func cmdAndDPressed() {
        toggleDirection()
    }
}
