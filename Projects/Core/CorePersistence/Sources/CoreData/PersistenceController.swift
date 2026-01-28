//
//  PersistenceController.swift
//  CorePersistence
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import SwiftUI
import CoreData

public final class PersistenceController: @unchecked Sendable {
    public static let shared = PersistenceController()
    
    public let container: NSPersistentContainer
    
    /// appGroupID: 위젯에서 수정까지 할 계획이면 App Group 경로를 지정
    public init(inMemory: Bool = false, appGroupID: String? = nil) {
        // 모든 가능한 번들에서 Core Data 모델 찾기
        var bundles: [Bundle] = [
            Bundle.main,
            Bundle(for: PersistenceController.self)
        ]
        
        // CorePersistence_CorePersistence.bundle 찾기
        if let resourceBundleURL = Bundle.main.url(forResource: "CorePersistence_CorePersistence", withExtension: "bundle"),
           let resourceBundle = Bundle(url: resourceBundleURL) {
            bundles.append(resourceBundle)
        }

        // CorePersistence.framework 번들 찾기
        if let identifier = Bundle(for: PersistenceController.self).bundleIdentifier,
           let frameworkBundle = Bundle(identifier: identifier) {
            bundles.append(frameworkBundle)
        }

        var modelURL: URL?
        for bundle in bundles {
            if let url = bundle.url(forResource: "FavoriteMovieModel", withExtension: "momd") {
                print("✅ [PersistenceController] 모델 찾음: \(url.path)")
                modelURL = url
                break
            }
        }
        
        guard let modelURL = modelURL else {
            let paths = bundles.map { "Bundle: \($0.bundlePath)" }.joined(separator: "\n")
            fatalError("Core Data 모델을 찾을 수 없습니다.\n확인한 번들:\n\(paths)")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Core Data 모델을 로드할 수 없습니다: \(modelURL.path)")
        }
        
        print("✅ [PersistenceController] 모델 로드 성공")
        container = NSPersistentContainer(name: "FavoriteMovieModel", managedObjectModel: managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        } else if let groupID = appGroupID,
                  let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
            description.url = dir.appendingPathComponent("FavoriteMovieModel.sqlite")
        } else {
            description.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("FavoriteMovieModel.sqlite")
        }
        
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data load error: \(error)") }
        }
        
        let ctx = container.viewContext
        ctx.automaticallyMergesChangesFromParent = true
        ctx.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        ctx.undoManager = nil
    }
}
