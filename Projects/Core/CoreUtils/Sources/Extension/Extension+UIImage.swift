//
//  Extension+UIImage.swift
//  CoreUtils
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

public extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
