//
//  Image.swift
//  DesignSystem
//
//  Created by 박서연 on 1/6/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

public enum DSImage {
    case close
    case emptyGood
    case error
    case fillPause
    case fillPlay
    case info
    case search

    public var image: UIImage {
        UIImage(
            named: name,
            in: DesignSystemBundle.bundle,
            compatibleWith: nil
        )!
    }

    private var name: String {
        switch self {
        case .close:       return "ic_close"
        case .emptyGood:   return "ic_empty_good"
        case .error:       return "ic_error"
        case .fillPause:   return "ic_fill_pause"
        case .fillPlay:    return "ic_fill_play"
        case .info:        return "ic_info"
        case .search:      return "ic_search"
        }
    }
}

public enum DesignSystemBundle {
    public static let bundle: Bundle = {
        Bundle(for: BundleToken.self)
    }()
}

private final class BundleToken {}
