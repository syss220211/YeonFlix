//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let CoreUIProject = Project.makeCoreModule(
    name: "CoreUI",
    isResource: false,
    dependencies: [
        .external(name: "Kingfisher"),
        .external(name: "SnapKit")
    ]
)
