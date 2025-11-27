//
//  Project+Template.swift
//  Manifests
//
//  Created by 박서연 on 7/14/25.
//

import ProjectDescription

public extension Project {
    /// MARK: - App 모듈 생성
    static func makeAppModule(
        name: String,
        dependencies: [TargetDependency]
    ) -> Project {
        let target = Target.target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "\(Environment.organizationName).\(Environment.appName).\(name)",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .file(path: .relativeToRoot("Tuist/Config/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: Settings.defaultTargetSettings()
        )

        return Project(
            name: name,
            organizationName: Environment.organizationName,
            options: .options(),
            targets: [target]
        )
    }

    /// MARK: - Feature 모듈 생성
    static func makeFeatureModule(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Environment.organizationName).\(Environment.appName).\(name)",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: Settings.defaultTargetSettings()
        )

        return Project(
            name: name,
            organizationName: Environment.organizationName,
            targets: [target]
        )
    }

    /// MARK: - Core 모듈 생성
    static func makeCoreModule(
        name: String,
        isResource: Bool,
        dependencies: [TargetDependency] = []
    ) -> Project {

        let target = Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Environment.organizationName).\(Environment.appName).\(name)",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: isResource ? ["Resources/**"] : [],
            dependencies: dependencies,
            settings: Settings.defaultTargetSettings()
        )

        return Project(
            name: name,
            organizationName: Environment.organizationName,
            targets: [target]
        )
    }
    
    /// MARK: - DesignSystem 모듈 생성
    static func makeDesignSystemModule(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Environment.organizationName).\(Environment.appName).\(name)",
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: Settings.defaultTargetSettings()
        )

        return Project(
            name: name,
            organizationName: Environment.organizationName,
            targets: [target]
        )
    }
}
