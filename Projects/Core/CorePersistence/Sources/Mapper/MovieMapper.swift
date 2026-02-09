//
//  MovieMapper.swift
//  CorePersistence
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation
import CoreData
import CoreModels

public enum MovieMapper {
    /// CoreData Movie → Domain FavoriteMovieEntity 변환
    public static func toDomain(_ movie: Movie) -> FavoriteMovieEntity {
        return FavoriteMovieEntity(
            movieID: Int(movie.movieID),
            title: movie.title ?? "",
            posterPath: movie.posterPath,
            movieDescription: movie.movieDescription ?? ""
        )
    }

    /// Domain FavoriteMovieEntity → CoreData Movie 변환
    public static func toCoreData(
        _ entity: FavoriteMovieEntity,
        context: NSManagedObjectContext
    ) -> Movie {
        let movie = Movie(context: context)
        movie.movieID = Int64(entity.movieID)
        movie.title = entity.title
        movie.posterPath = entity.posterPath
        movie.movieDescription = entity.movieDescription
        return movie
    }
}
