//
//  Environment.swift
//  Manifests
//
//  Created by 박서연 on 7/13/25.
//

import ProjectDescription

public enum Environment {
    public static let appName: String = "YeonFlex"
    public static let organizationName = "linda"
    public static let destinations: Destinations = [.iPhone]
    public static let deploymentTarget: DeploymentTargets = .iOS("16.0")
}
