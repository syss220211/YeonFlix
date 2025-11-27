//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/27/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let designSystemProject = Project.makeDesignSystemModule(
    name: "DesignSystem",
    dependencies: [
        .project(target: "CoreUI", path: "../Core/CoreUI")
    ]
)
