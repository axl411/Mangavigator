//
//  Styles.swift
//  Mangavigator
//
//  Created by axl411 on 2018/09/02.
//  Copyright © 2018 (null). All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import Cocoa

public class Styles : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawCanvas1(frame targetFrame: NSRect = NSRect(x: 0, y: 0, width: 240, height: 90), resizing: ResizingBehavior = .aspectFit, fileName: String = "Thumbs.db") {
        //// General Declarations
        let context = NSGraphicsContext.current!.cgContext

        //// Resize to Target Frame
        NSGraphicsContext.saveGraphicsState()
        let resizedFrame: NSRect = resizing.apply(rect: NSRect(x: 0, y: 0, width: 240, height: 90), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 90)


        //// Text Drawing
        let textRect = NSRect(x: 0, y: 0, width: 240, height: 32)
        let textTextContent = "is not an image"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: NSFont.systemFont(ofSize: 17),
            .foregroundColor: NSColor.black,
            .paragraphStyle: textStyle,
            ] as [NSAttributedString.Key: Any]

        let textTextHeight: CGFloat = textTextContent.boundingRect(with: NSSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes).height
        let textTextRect: NSRect = NSRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight)
        NSGraphicsContext.saveGraphicsState()
        textRect.clip()
        textTextContent.draw(in: textTextRect.offsetBy(dx: 0, dy: 0.5), withAttributes: textFontAttributes)
        NSGraphicsContext.restoreGraphicsState()


        //// Text 2 Drawing
        let text2Rect = NSRect(x: 66, y: 36, width: 108, height: 21)
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .center
        let text2FontAttributes = [
            .font: NSFont.systemFont(ofSize: 17),
            .foregroundColor: NSColor.black,
            .paragraphStyle: text2Style,
            ] as [NSAttributedString.Key: Any]

        let text2TextHeight: CGFloat = fileName.boundingRect(with: NSSize(width: text2Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text2FontAttributes).height
        let text2TextRect: NSRect = NSRect(x: text2Rect.minX, y: text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, width: text2Rect.width, height: text2TextHeight)
        NSGraphicsContext.saveGraphicsState()
        text2Rect.clip()
        fileName.draw(in: text2TextRect.offsetBy(dx: 0, dy: 0.5), withAttributes: text2FontAttributes)
        NSGraphicsContext.restoreGraphicsState()


        //// Text 3 Drawing
        let text3Rect = NSRect(x: 66, y: 56, width: 108, height: 34)
        let text3TextContent = "🤪"
        let text3Style = NSMutableParagraphStyle()
        text3Style.alignment = .center
        let text3FontAttributes = [
            .font: NSFont.systemFont(ofSize: 17),
            .foregroundColor: NSColor.black,
            .paragraphStyle: text3Style,
            ] as [NSAttributedString.Key: Any]

        let text3TextHeight: CGFloat = text3TextContent.boundingRect(with: NSSize(width: text3Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text3FontAttributes).height
        let text3TextRect: NSRect = NSRect(x: text3Rect.minX, y: text3Rect.minY + (text3Rect.height - text3TextHeight) / 2, width: text3Rect.width, height: text3TextHeight)
        NSGraphicsContext.saveGraphicsState()
        text3Rect.clip()
        text3TextContent.draw(in: text3TextRect.offsetBy(dx: 0, dy: 2.5), withAttributes: text3FontAttributes)
        NSGraphicsContext.restoreGraphicsState()

        NSGraphicsContext.restoreGraphicsState()

    }




    @objc(StylesResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: NSRect, target: NSRect) -> NSRect {
            if rect == target || target == NSRect.zero {
                return rect
            }

            var scales = NSSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
