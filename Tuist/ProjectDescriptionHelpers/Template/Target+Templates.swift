//
//  Target+Template.swift
//  Manifests
//
//  Created by 박서연 on 7/13/25.
//

import ProjectDescription

public extension Target {
    static func make(
        name: String,
        product: Product,
        dependencies: [TargetDependency] = []
    ) -> Target {

        return Target.target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: "\(Environment.organizationName).\(Environment.appName).\(name)",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies
        )
    }
}
