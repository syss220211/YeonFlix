//
//  AuthHeaderProvider.swift
//  CoreSecurity
//
//  Created by 박서연 on 12/20/25.
//  Copyright © 2025 linda. All rights reserved.
//

public protocol AuthHeaderProvider {
    func makeAuthHeader() -> [String: String]?
}
