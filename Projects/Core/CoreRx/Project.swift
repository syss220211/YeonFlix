//
//  Project.swift
//  CoreCommonUIManifests
//
//  Created by 박서연 on 12/28/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let CoreRxProject = Project.makeCoreModule(
    name: "CoreRx",
    isResource: false,
    dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxRelay")
    ]
)
