//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let CoreUIProject = Project.makeCoreModule(
    name: "CoreCommonUI",
    isResource: false,
    dependencies: [
        .external(name: "Kingfisher"),
        .external(name: "SnapKit"),
        .project(target: "DesignSystem", path: "../../DesignSystem")
    ]
)
