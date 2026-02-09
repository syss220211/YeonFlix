//
//  FavoriteMovieManager.swift
//  CorePersistence
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import CoreData
import CoreModels


@MainActor
public final class FavoriteMovieManager {
    public static let shared = FavoriteMovieManager()

    private let persistenceController: PersistenceController
    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    // MARK: - Reactive State
    /// 즐겨찾기 목록이 변경될 때마다 이벤트 방출
    private let favoritesChangeRelay = PublishRelay<Void>()

    /// 즐겨찾기 변경 이벤트 스트림 (다른 모듈에서 구독 가능)
    public var favoritesDidChange: Observable<Void> {
        favoritesChangeRelay.asObservable()
    }

    private init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    // MARK: - CRUD Operations

    /// 즐겨찾기 영화 저장
    public func saveFavoriteMovie(movieID: Int, title: String, posterPath: String?, movieDescription: String) throws {
        // 이미 존재하는지 확인
        if isFavorite(movieID: movieID) {
            print("⚠️ [FavoriteMovieManager] 이미 즐겨찾기에 추가된 영화입니다: \(movieID)")
            return
        }

        let entity = FavoriteMovieEntity(
            movieID: movieID,
            title: title,
            posterPath: posterPath,
            movieDescription: movieDescription
        )

        _ = MovieMapper.toCoreData(entity, context: context)

        try context.save()
        print("✅ [FavoriteMovieManager] 즐겨찾기 저장 완료: \(title)")

        // 변경 이벤트 방출
        favoritesChangeRelay.accept(())
    }

    /// 모든 즐겨찾기 영화 가져오기
    public func getFavoriteMovies() throws -> [FavoriteMovieEntity] {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let movies = try context.fetch(fetchRequest)
        return movies.map { MovieMapper.toDomain($0) }
    }

    /// 즐겨찾기 영화 삭제
    public func deleteFavoriteMovie(movieID: Int) throws {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %d", movieID)

        let movies = try context.fetch(fetchRequest)

        guard let movie = movies.first else {
            print("⚠️ [FavoriteMovieManager] 삭제할 영화를 찾을 수 없습니다: \(movieID)")
            return
        }

        context.delete(movie)
        try context.save()
        print("✅ [FavoriteMovieManager] 즐겨찾기 삭제 완료: \(movieID)")

        // 변경 이벤트 방출
        favoritesChangeRelay.accept(())
    }

    /// 즐겨찾기 여부 확인
    public func isFavorite(movieID: Int) -> Bool {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %d", movieID)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("❌ [FavoriteMovieManager] isFavorite 확인 실패: \(error)")
            return false
        }
    }

    /// 즐겨찾기 토글 (있으면 삭제, 없으면 추가)
    public func toggleFavorite(movieID: Int, title: String, posterPath: String?, movieDescription: String) throws {
        if isFavorite(movieID: movieID) {
            try deleteFavoriteMovie(movieID: movieID)
        } else {
            try saveFavoriteMovie(movieID: movieID, title: title, posterPath: posterPath, movieDescription: movieDescription)
        }
    }

    /// 모든 즐겨찾기 삭제
    public func deleteAllFavorites() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.execute(deleteRequest)
        try context.save()
        print("✅ [FavoriteMovieManager] 모든 즐겨찾기 삭제 완료")

        // 변경 이벤트 방출
        favoritesChangeRelay.accept(())
    }
}
