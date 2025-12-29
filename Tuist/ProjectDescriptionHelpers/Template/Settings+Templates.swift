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
                "OTHER_SWIFT_FLAGS": [
                    "$(inherited)",
                    "-DMYCUSTOMFLAG"
                ]
            ],
            configurations: [
                .debug(
                    name: .debug,
                    settings: [
                        "OTHER_SWIFT_FLAGS": [
                            "$(inherited)",
                            "-DDEBUG"
                        ]
                    ],
                    xcconfig: .relativeToRoot("Tuist/Config/Secrets.xcconfig")
                ),
                .release(
                    name: .release,
                    settings: [
                        "OTHER_SWIFT_FLAGS": [
                            "$(inherited)",
                            "-DRELEASE"
                        ]
                    ],
                    xcconfig: .relativeToRoot("Tuist/Config/Secrets.xcconfig")
                )
            ],
            defaultSettings: DefaultSettings.recommended
            // defaultConfiguration: 이거는 프로젝트 세팅에서 설정하는 것
        )
    }
}
