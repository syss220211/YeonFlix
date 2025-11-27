//
//  Workspace.swift
//  Manifests
//
//  Created by 박서연 on 7/19/25.
//

import ProjectDescription

let workspace = Workspace(
    name: "YeonFlix",
    projects: [
        "Projects/YeonFlixApp",
        "Projects/Features/**",
        "Projects/Core/**",
        "Projects/DesignSystem/**"
    ]
)
