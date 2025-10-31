//
// UIImage+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

extension UIImage {
    static func image(from baseFolder: String, named name: String, bundle: Bundle = Bundle.module) -> UIImage? {
        if let image = UIImage(named: "\(baseFolder)/\(name)", in: bundle, with: nil) {
            return image
        }
        return UIImage(named: "Default/\(name)", in: bundle, with: nil)
    }

    public static func createImage(color: UIColor, size: CGSize) -> UIImage? {
        var rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    public func tintImage(tintColor: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }

    private func modifiedImage(draw: (CGContext, CGRect) -> Void) -> UIImage {
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    public func resizedImage(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension UIImage {
    static func createWithText(text: String, backgroundColor: UIColor, textColor: UIColor, size: CGSize, font: UIFont, cornerRadius: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()

        backgroundColor.setFill()
        path.fill()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: textColor
        ]

        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(x: (size.width - textSize.width) / 2,
                              y: (size.height - textSize.height) / 2,
                              width: textSize.width,
                              height: textSize.height)

        text.draw(in: textRect, withAttributes: attributes)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension UIImage {
    func addTextToImage(text: String?) -> UIImage? {
        guard let text = text, text != ""  else {
            return self
        }
        
        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: 14)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ]
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        
        //Put the image into a rectangle as large as the original image.
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y: drawingBounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)
        
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImag
        
    }
}


