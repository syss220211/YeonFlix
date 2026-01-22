//
//  MovieDetailEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/22/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct MovieDetailEntity: Sendable, Equatable {
    public let id: Int
    public let title: String
    public let originalTitle: String?
    public let overview: String?
    public let tagline: String?
    public let status: String?
    public let releaseDate: String?
    public let runtime: Int?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let popularity: Double?
    public let posterPath: String?
    public let backdropPath: String?
    public let video: Bool
    public let adult: Bool
    public let imdbId: String?
    public let homepage: String?
    public let originCountry: [String]
    public let budget: Int?
    public let revenue: Int?
    public let genres: [MovieGenreEntity]
    public let belongsToCollection: MovieCollectionEntity?
    public let productionCompanies: [ProductionCompanyEntity]
    public let productionCountries: [ProductionCountryEntity]
    public let spokenLanguages: [SpokenLanguageEntity]

    public init(
        id: Int,
        title: String,
        originalTitle: String?,
        overview: String?,
        tagline: String?,
        status: String?,
        releaseDate: String?,
        runtime: Int?,
        voteAverage: Double?,
        voteCount: Int?,
        popularity: Double?,
        posterPath: String?,
        backdropPath: String?,
        video: Bool,
        adult: Bool,
        imdbId: String?,
        homepage: String?,
        originCountry: [String],
        budget: Int?,
        revenue: Int?,
        genres: [MovieGenreEntity],
        belongsToCollection: MovieCollectionEntity?,
        productionCompanies: [ProductionCompanyEntity],
        productionCountries: [ProductionCountryEntity],
        spokenLanguages: [SpokenLanguageEntity]
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.tagline = tagline
        self.status = status
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.popularity = popularity
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.video = video
        self.adult = adult
        self.imdbId = imdbId
        self.homepage = homepage
        self.originCountry = originCountry
        self.budget = budget
        self.revenue = revenue
        self.genres = genres
        self.belongsToCollection = belongsToCollection
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
    }
}

// MARK: - MovieGenre
public struct MovieGenreEntity: Sendable, Equatable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - MovieCollection
public struct MovieCollectionEntity: Sendable, Equatable {
    public let id: Int
    public let name: String
    public let posterPath: String?
    public let backdropPath: String?
    
    public init(id: Int, name: String, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

// MARK: - ProductionCompany
public struct ProductionCompanyEntity: Sendable, Equatable {
    public let id: Int
    public let name: String
    public let logoPath: String?
    public let originCountry: String?
    
    public init(id: Int, name: String, logoPath: String?, originCountry: String?) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }
}

// MARK: - ProductionCountry
public struct ProductionCountryEntity: Sendable, Equatable {
    public let isoCode: String?
    public let name: String?
    
    public init(isoCode: String?, name: String?) {
        self.isoCode = isoCode
        self.name = name
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguageEntity: Sendable, Equatable {
    public let englishName: String?
    public let isoCode: String?
    public let name: String?
    
    public init(englishName: String?, isoCode: String?, name: String?) {
        self.englishName = englishName
        self.isoCode = isoCode
        self.name = name
    }
}
