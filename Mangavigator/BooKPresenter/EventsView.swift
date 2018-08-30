//
//  EventsView.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/12.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

protocol EventsViewDelegate: class {
    func rightPressed()
    func leftPressed()
    func mouseMoved()
}

class EventsView: NSView {
    weak var delegate: EventsViewDelegate?

    override var acceptsFirstResponder: Bool { return true }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseMoved, .activeWhenFirstResponder],
            owner: self
        ))
    }

    override func moveRight(_ sender: Any?) {
        delegate?.rightPressed()
    }

    override func moveLeft(_ sender: Any?) {
        delegate?.leftPressed()
    }

    override func mouseMoved(with event: NSEvent) {
        delegate?.mouseMoved()
    }
}
