//
//  MovieDetailDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/22/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation
/*
 enum MovieVideoType: String {
     case trailer = "Trailer"
     case teaser = "Teaser"
     case clip = "Clip"
     case featurette = "Featurette"
     case behindTheScenes = "Behind the Scenes"
     case bloopers = "Bloopers"
     case interview = "Interview"
     case openingCredits = "Opening Credits"
     case unknown
 }
 */

public struct MovieDetailDTO: Decodable, Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollectionDTO?
    public let budget: Int?
    public let genres: [GenreDTO]
    public let homepage: String?
    public let id: Int
    public let imdbId: String?
    public let originCountry: [String]?
    public let originalLanguage: String?
    public let originalTitle: String?
    public let overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompanyDTO]?
    public let productionCountries: [ProductionCountryDTO]?
    public let releaseDate: String?
    public let revenue: Int?
    public let runtime: Int?
    public let spokenLanguages: [SpokenLanguageDTO]?
    public let status: String?
    public let tagline: String?
    public let title: String?
    public let video: Bool
    public let voteAverage: Double?
    public let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public struct BelongsToCollectionDTO: Decodable, Sendable {
    public let id: Int
    public let name: String?
    public let posterPath: String?
    public let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

public struct GenreDTO: Decodable, Sendable {
    public let id: Int
    public let name: String?
}

public struct ProductionCompanyDTO: Decodable, Sendable {
    public let id: Int
    public let logoPath: String?
    public let name: String?
    public let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

public struct ProductionCountryDTO: Decodable, Sendable {
    public let iso3166_1: String?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

public struct SpokenLanguageDTO: Decodable, Sendable {
    public let englishName: String?
    public let iso639_1: String?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

public extension MovieDetailDTO {
    func toDomain() -> MovieDetailEntity {
        return MovieDetailEntity(
            id: id,
            title: (title?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty)
            ?? (originalTitle?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty)
            ?? "Unknown",
            originalTitle: originalTitle,
            overview: overview,
            tagline: tagline?.nilIfEmpty,
            status: status,
            releaseDate: releaseDate,
            runtime: runtime,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            posterPath: posterPath,
            backdropPath: backdropPath,
            video: video,
            adult: adult,
            imdbId: imdbId,
            homepage: homepage?.nilIfEmpty,
            originCountry: originCountry ?? [],
            budget: budget,
            revenue: revenue,
            genres: genres.map { $0.toDomain() },
            belongsToCollection: belongsToCollection?.toDomain(),
            productionCompanies: (productionCompanies ?? []).map { $0.toDomain() },
            productionCountries: (productionCountries ?? []).map { $0.toDomain() },
            spokenLanguages: (spokenLanguages ?? []).map { $0.toDomain() }
        )
    }
}

public extension GenreDTO {
    func toDomain() -> MovieGenreEntity {
        MovieGenreEntity(
            id: id,
            name: name?.nilIfEmpty ?? ""
        )
    }
}

public extension BelongsToCollectionDTO {
    func toDomain() -> MovieCollectionEntity {
        MovieCollectionEntity(
            id: id,
            name: name?.nilIfEmpty ?? "",
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }
}

public extension ProductionCompanyDTO {
    func toDomain() -> ProductionCompanyEntity {
        ProductionCompanyEntity(
            id: id,
            name: name?.nilIfEmpty ?? "",
            logoPath: logoPath,
            originCountry: originCountry
        )
    }
}

public extension ProductionCountryDTO {
    func toDomain() -> ProductionCountryEntity {
        ProductionCountryEntity(
            isoCode: iso3166_1,
            name: name
        )
    }
}

public extension SpokenLanguageDTO {
    func toDomain() -> SpokenLanguageEntity {
        SpokenLanguageEntity(
            englishName: englishName,
            isoCode: iso639_1,
            name: name
        )
    }
}

// MARK: - Helpers
public extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
