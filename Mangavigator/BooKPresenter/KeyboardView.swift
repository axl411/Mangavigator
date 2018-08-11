//
//  KeyboardView.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/12.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

class KeyboardView: NSView {
    override var acceptsFirstResponder: Bool { return true }

    override func keyUp(with event: NSEvent) {
        print(event)
    }
}
