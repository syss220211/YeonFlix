//
//  Scheme+Template.swift
//  Manifests
//
//  Created by 박서연 on 7/16/25.
//

import ProjectDescription

public extension Scheme {
    static func scheme(
        schemeName: String,
        targetName: String,
        configurationName: ConfigurationName
    ) -> Scheme {
        let isRelease = configurationName == .release
        return Scheme.scheme(
            name: schemeName,
            shared: true,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            runAction: .runAction(configuration: configurationName),
            archiveAction: .archiveAction(configuration: isRelease ? .release : configurationName),
            profileAction: .profileAction(configuration: isRelease ? .release : configurationName),
            analyzeAction: .analyzeAction(configuration: configurationName)
        )
    }
}

