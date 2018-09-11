//
//  NSImage+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/09/09.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

extension NSImage {
    func resized(to targetSize: CGSize) -> NSImage {
        let imageSize = size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat  = 0.0
        var scaledWidth  = targetWidth
        var scaledHeight = targetHeight

        var thumbnailPoint = NSPoint.zero

        if imageSize != targetSize {
            let widthFactor  = targetWidth / width
            let heightFactor = targetHeight / height

            if widthFactor < heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }

            scaledWidth  = width  * scaleFactor
            scaledHeight = height * scaleFactor

            if widthFactor < heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor > heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }

            let newImage = NSImage(size: targetSize)
            newImage.lockFocus()
            let thumbnailRect = NSRect(
                origin: thumbnailPoint,
                size: CGSize(width: scaledWidth, height: scaledHeight)
            )
            draw(
                in: thumbnailRect,
                from: .zero,
                operation: .sourceOver,
                fraction: 1.0
            )

            newImage.unlockFocus()

            return newImage
        } else {
            return self
        }
    }
}
