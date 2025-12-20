//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let coreNetworkProject = Project.makeCoreModule(
    name: "CoreNetwork",
    isResource: false,
    dependencies: [
        .project(target: "CoreSecurity", path: "../../Core/CoreSecurity")
    ]
)
