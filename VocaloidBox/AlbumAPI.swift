//
//  AlbumAPI.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

struct AlbumAPI: Codable{
    
//    let additionalNames: String
//    let artists: [ArtistContainerAPI]
    let artistString: String
//    let barcode: String
//    let catalogNumber: String
    let createDate: String
    let defaultName: String
    let defaultNameLanguage: String
//    let deleted: Bool
//    let descpription: String
//    let discs: [DiscAPI]
    let discType: String
    let id: Int
    let name: String
    let ratingAverage: Float
    let ratingCount: Int
    let releaseDate: ReleaseDate
    let status: String
    let version: Int
    let mainPicture: MainPictureAPI?
    let tracks: [TrackAPI]
}

struct ArtistContainerAPI: Codable {
    let artist: ArtistAPI
    let categories: String
    let effectiveRoles: String
    let isSupport: Bool
    let name: String
    let roles: String
}

struct ArtistAPI: Codable {
    let additionalNames: String
    let artistType: String
    let deleted: Bool
    let id: Int
    let name: String
    let pictureMime: String
    let releaseDate: String
    let status: String
    let version: Int
}

struct DiscAPI: Codable {
    let discNUmber: Int
    let id: Int
    let mediaType: String
    let name: String
}

struct MainPictureAPI: Codable {
    let mime: String
    let urlSmallThumb: String
    let urlThumb: String
    let urlTinyThumb: String
    
}

struct TrackAPI: Codable {
    let discNumber: Int
    let id: Int
    let name: String
    let song: SongAPI?
    let trackNumber: Int
}

struct SongAPI: Codable {
    let artistString: String
    let createDate: String
    let defaultName: String
    let defaultNameLanguage: String
    let favoritedTimes: Int
    let id: Int
    let lengthSeconds: Int
    let name: String
    let pvServices: String
    let ratingScore: Int
    let songType: String
    let status: String
    let version: Int
}

struct DetailedSongAPI: Codable {
    let artistString: String
    let createDate: String
    let defaultName: String
    let defaultNameLanguage: String
    let favoritedTimes: Int
    let id: Int
    let lengthSeconds: Int
    let name: String
    let publishDate: String?
    let pvs: [PVAPI]
    let pvServices: String
    let ratingScore: Int
    let songType: String
    let status: String
    let version: Int
}

struct PVAPI: Codable {
    let author: String
    let disabled: Bool
    let id: Int
    let length: Int
    let name: String
    let publishDate: String?
    let pvId: String
    let service: String
    let pvType: String
    let thumbUrl: String
    let url: String
}


