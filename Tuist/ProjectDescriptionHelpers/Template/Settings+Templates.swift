//
//  Settings+Template.swift
//  Manifests
//
//  Created by 박서연 on 7/16/25.
//

import ProjectDescription

public extension Settings {
    static func defaultTargetSettings() -> Settings {
        return Settings.settings(
            base: [
                "SWIFT_VERSION": "6.0",
                // Swift 버전 고정
                "IPHONEOS_DEPLOYMENT_TARGET": "16.0", // 최소 지원 타겟 고정,
                "OTHER_LDFLAGS": "-ObjC", // 카테고리나 메타데이터가 포함된 정적 라이브러리의 코드가 런타임에 정상 동작하도록 설정
            ],
            configurations: [
                .debug(
                    name: .debug,
                    settings: [
                        "OTHER_SWIFT_FLAGS": "-DDEBUG", //  #if DEBUG 조건을 가능하도록 설정
                    ],
                    xcconfig: .relativeToRoot("Tuist/Config/Secrets.xcconfig")
                ),
                .release(
                    name: .release,
                    settings: [
                        "OTHER_SWIFT_FLAGS": ["-DRELEASE"], // Swift 코드에서 #if RELEASE 조건을 가능하게 함
                    ],
                    xcconfig: .relativeToRoot("Tuist/Config/Secrets.xcconfig")
                )
            ],
            defaultSettings: DefaultSettings.recommended
            // defaultConfiguration: 이거는 프로젝트 세팅에서 설정하는 것
        )
    }
}
