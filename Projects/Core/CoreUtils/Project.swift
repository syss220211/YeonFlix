//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let coreUtilsProject = Project.makeCoreModule(
    name: "CoreUtils",
    isResource: false,
    dependencies: [
//        .project(target: "DesignSystem", path: "../../DesignSystem")
    ]
)
