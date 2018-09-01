//
//  Images.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/02.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

struct Images {
    static func nonImageImage(size: CGSize, fileName: String) -> NSImage {
        return drawImageInNSGraphicsContext(size: size) {
            Styles.drawCanvas1(frame: NSRect(origin: .zero, size: size), resizing: .aspectFit, fileName: fileName)
        }
    }
}

private func drawImageInNSGraphicsContext(size: CGSize, drawFunc: ()->()) -> NSImage {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size.width),
        pixelsHigh: Int(size.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: NSColorSpaceName.calibratedRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0)

    let context = NSGraphicsContext(bitmapImageRep: rep!)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context

    drawFunc()

    NSGraphicsContext.restoreGraphicsState()

    let image = NSImage(size: size)
    image.addRepresentation(rep!)

    return image
}

