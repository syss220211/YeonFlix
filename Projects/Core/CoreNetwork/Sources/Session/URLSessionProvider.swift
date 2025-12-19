//
//  URLSessionProvider.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public protocol URLSessionProvider {
    var session: URLSessionProtocol { get }
}

public final class DefaultURLSessionProvider: URLSessionProvider {
    public let session: URLSessionProtocol

    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    public init(session: URLSessionProtocol) {
        self.session = session
    }
}
