//
//  Project.swift
//  Manifests
//
//  Created by 박서연 on 1/28/26.
//


import ProjectDescription
import ProjectDescriptionHelpers

let CorePersistenceProject = Project.makeCoreModule(
    name: "CorePersistence",
    isResource: false,
    dependencies: [
        .project(target: "CoreModels", path: .relativeToRoot("Projects/Core/CoreModels"))
    ],
    coreModel: [.coreDataModel("Resources/FavoriteMovieModel.xcdatamodeld")]
)
