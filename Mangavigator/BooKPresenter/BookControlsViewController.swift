//
//  BookControlsViewController.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/28.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

private let nameLabelInset: CGFloat = 40

protocol BookControlsViewControllerDelegate: AnyObject {
    func mouseEntered()
    func mouseLeft()
}

class BookControlsViewController: NSViewController {
    static let viewBackgroundAlpha: CGFloat = 0.6

    private let book: Book
    private var bookIndexObserving: NSKeyValueObservation?
    private let textField: NSTextField = {
        let textField = NSTextField()
        textField.alignment = .center
        textField.font = NSFont.labelFont(ofSize: 20)
        textField.backgroundColor = NSColor(white: 0, alpha: viewBackgroundAlpha)
        textField.textColor = NSColor(white: 1, alpha: 1)
        textField.isEditable = false
        textField.isBezeled = false
        textField.isSelectable = false
        return textField
    }()
    private lazy var slider: PreviewableSlider = {
        let slider = PreviewableSlider(
            value: 0.0,
            minValue: 0.0,
            maxValue: 1.0,
            target: nil,
            action: nil
        )
        slider.delegate = self
        slider.isVertical = true
        return slider
    }()
    weak var delegate: BookControlsViewControllerDelegate?

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

        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            slider.widthAnchor.constraint(equalToConstant: 50)
        ])

        bookIndexObserving = book.observe(
            \.currentIndex,
            options: [.initial, .new, .old]
        ) { [weak self] (_, change) in
            guard
                let `self` = self,
                let newValue = change.newValue
                else { return }
            self.slider.doubleValue = Double(self.book.percentage(forIndex: newValue))
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        textField.preferredMaxLayoutWidth = view.frame.width - nameLabelInset * 2
    }
}

extension BookControlsViewController: PreviewableSliderDelegate {
    func mouseEntered() {
        delegate?.mouseEntered()
    }

    func mouseLeft() {
        delegate?.mouseLeft()
    }

    func didSelectPercentage(_ percentage: CGFloat) {
        book.goToIndex(book.index(forPercentage: percentage))
        // TODO: BUG: when dragging the slider then release, the percentage still reflect the position where the mouse is pressed down
    }

    func previewImage(requestingPercentage: CGFloat, requestedPercentage: CGFloat?) -> NSImage? {
        guard let requestedPercentage = requestedPercentage else { return nil }
        let requestingIndex = book.index(forPercentage: requestingPercentage)
        let requestedIndex = book.index(forPercentage: requestedPercentage)
        guard requestingIndex != requestedIndex else { return nil }

        print(requestingIndex)
        let bookPage = book.getPreviewPage(forIndex: requestingIndex, size: PreviewableSlider.previewSize)
        if case .image(let image) = bookPage {
            return image
        } else {
            return nil
        }
    }
}
