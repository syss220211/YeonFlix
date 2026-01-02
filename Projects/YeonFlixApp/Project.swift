//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 7/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeAppModule(
    name: "YeonFlixApp",
    dependencies: [
        .project(target: "HomeFeature", path: "../Features/HomeFeature"),
        .project(target: "SearchFeature", path: "../Features/SearchFeature"),
        .project(target: "MovieFeature", path: "../Features/MovieFeature"),
        .project(target: "MypageFeature", path: "../Features/MypageFeature")
    ]
)
