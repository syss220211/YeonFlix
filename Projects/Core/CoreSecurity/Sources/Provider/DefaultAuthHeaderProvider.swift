//
//  DefaultAuthHeaderProvider.swift
//  CoreSecurity
//
//  Created by 박서연 on 12/20/25.
//  Copyright © 2025 linda. All rights reserved.
//

public final class DefaultAuthHeaderProvider: AuthHeaderProvider {

    private let keyStore: APIKeyStore

    public init(keyStore: APIKeyStore) {
        self.keyStore = keyStore
    }

    public func makeAuthHeader() -> [String: String]? {
        guard let token = keyStore.fetch() else {
            return nil
        }
        return ["Authorization": "Bearer \(token)"]
    }
}
