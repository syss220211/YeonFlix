//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let homeFeatureProject = Project.makeFeatureModule(
    name: "HomeFeature",
    dependencies: [
        .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
        .project(target: "CoreModels", path: "../../Core/CoreModels"),
        .project(target: "CoreUtils", path: "../../Core/CoreUtils"),
        .project(target: "CoreUI", path: "../../Core/CoreUI"),
        .project(target: "DesignSystem", path: "../../DesignSystem")
    ]
)
