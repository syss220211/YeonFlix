//
//  APIKeyProtocol.swift
//  CoreSecurity
//
//  Created by 박서연 on 12/20/25.
//  Copyright © 2025 linda. All rights reserved.
//

/// info > secret에 있는 키를 token 처럼 활용하기 위한 KeyChain의 인터페이스 입니다.
public protocol APIKeyStore {
    func save(_ token: String) throws
    func fetch() -> String?
    func delete() throws
}
