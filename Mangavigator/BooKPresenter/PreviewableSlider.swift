//
//  PreviewableSlider.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/09.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

protocol PreviewableSliderDelegate: class {
    func previewImage(requestingPercentage: CGFloat, requestedPercentage: CGFloat?) -> NSImage?
    func didSelectPercentage(_ percentage: CGFloat)
}

class PreviewableSlider: NSSlider {
    static let previewSize = CGSize(width: 150, height: 200)

    public weak var delegate: PreviewableSliderDelegate?

    private let previewImageView: NSImageView = {
        let imageView = NSImageView(frame: NSRect(origin: .zero, size: PreviewableSlider.previewSize))
        imageView.imageAlignment = .alignBottom
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.isHidden = true
        return imageView
    }()

    private let progressText: NSText = {
        let text = NSText()
        text.wantsLayer = true
        text.layer?.backgroundColor = NSColor(white: 0, alpha: BookControlsViewController.viewBackgroundAlpha).cgColor
        return text
    }()

    private var requestedPreviewPercentage: CGFloat?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.masksToBounds = false
        sliderType = .linear
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 0, alpha: BookControlsViewController.viewBackgroundAlpha).cgColor

        addSubview(previewImageView)

        addSubview(progressText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var wantsDefaultClipping: Bool {
        return false
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow],
            owner: self
        ))
    }

    override func mouseEntered(with event: NSEvent) {
        previewImageView.isHidden = false
    }

    override func mouseExited(with event: NSEvent) {
        previewImageView.isHidden = true
    }

    override func mouseMoved(with event: NSEvent) {
        guard isHidden == false else { return }
        let y = convert(event.locationInWindow, from: nil).y
        let percentage = self.percentage(forYPosition: y)



        previewImageView.isHidden = false
        let previewX: CGFloat = -PreviewableSlider.previewSize.width
        let previewY = y - PreviewableSlider.previewSize.height / 2
        previewImageView.setFrameOrigin(NSPoint(x: previewX, y: previewY))

        var requestingPreviewPercentage: CGFloat?
        if let requestedPreviewPercentage = requestedPreviewPercentage {
            if requestedPreviewPercentage != percentage {
                requestingPreviewPercentage = percentage
            }
        } else {
            requestingPreviewPercentage = percentage
        }
        if let requestingPreviewPercentage = requestingPreviewPercentage {
            let image = delegate?.previewImage(
                requestingPercentage: requestingPreviewPercentage,
                requestedPercentage: requestedPreviewPercentage
            )
            if let image = image {
                previewImageView.image = image
            }
            requestedPreviewPercentage = requestingPreviewPercentage
        }
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let y = convert(event.locationInWindow, from: nil).y
        let percentage = self.percentage(forYPosition: y)
        delegate?.didSelectPercentage(percentage)
    }

    private func percentage(forYPosition y: CGFloat) -> CGFloat {
        let rawPercentage = ((1 - y / bounds.height) * 1000).rounded(.toNearestOrAwayFromZero) / 1000
        let percentage = min(1, max(0, rawPercentage))
        return percentage
    }
}
