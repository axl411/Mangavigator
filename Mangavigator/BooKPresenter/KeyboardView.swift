//
//  KeyboardView.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/12.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

protocol KeyboardViewDelegate: class {
    func rightPressed()
    func leftPressed()
}

class KeyboardView: NSView {
    private static let rightArrowString = Unicode.Scalar(NSRightArrowFunctionKey).flatMap { String($0) }
    private static let leftArrowString = Unicode.Scalar(NSLeftArrowFunctionKey).flatMap { String($0) }

    weak var delegate: KeyboardViewDelegate?

    override var acceptsFirstResponder: Bool { return true }

    override func keyDown(with event: NSEvent) {
        switch event.characters {
        case KeyboardView.rightArrowString:
            delegate?.rightPressed()
        case KeyboardView.leftArrowString:
            delegate?.leftPressed()
        default:
            super.keyDown(with: event)
        }
    }
}
