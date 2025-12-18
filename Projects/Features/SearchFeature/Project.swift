//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let searchFeatureProject = Project.makeFeatureModule(
    name: "SearchFeature",
    dependencies: [
        .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
        .project(target: "CoreModels", path: "../../Core/CoreModels"),
        .project(target: "CoreUtils", path: "../../Core/CoreUtils"),
        .project(target: "CoreCommonUI", path: "../../Core/CoreCommonUI"),
        .project(target: "DesignSystem", path: "../../DesignSystem"),
        .external(name: "RxSwift")
    ]
)
