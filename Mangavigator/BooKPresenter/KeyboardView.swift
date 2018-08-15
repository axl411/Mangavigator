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
    weak var delegate: KeyboardViewDelegate?

    override var acceptsFirstResponder: Bool { return true }

    override func moveRight(_ sender: Any?) {
        delegate?.rightPressed()
    }

    override func moveLeft(_ sender: Any?) {
        delegate?.leftPressed()
    }
}
