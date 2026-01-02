//
//  Project.swift
//  CoreCommonUIManifests
//
//  Created by 박서연 on 12/30/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let MypageFeatureProject = Project.makeFeatureModule(
    name: "MypageFeature",
    dependencies: [
        .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
        .project(target: "CoreModels", path: "../../Core/CoreModels"),
        .project(target: "CoreUtils", path: "../../Core/CoreUtils"),
        .project(target: "CoreCommonUI", path: "../../Core/CoreCommonUI"),
        .project(target: "DesignSystem", path: "../../DesignSystem"),
        .project(target: "CoreSecurity", path: "../../Core/CoreSecurity"),
        .project(target: "CoreRx", path: "../../Core/CoreRx"),
    ]
)
