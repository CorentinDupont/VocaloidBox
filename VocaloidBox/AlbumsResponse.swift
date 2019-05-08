//
//  AlbumsResponse.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

struct AlbumsResponse: Codable{
    
//    enum CodingKeys: String, CodingKey {
//        case items
//        case terms
//        case totalCount
//    }
//
//    enum AlbumResponseKeys: String, CodingKey {
//        case albumResponse
//    }
//
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: AlbumResponseKeys.self)
//        let albumResponseValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .albumResponse)
//        items = try albumResponseValues.decode([AlbumAPI].self, forKey: .items)
//        terms = try albumResponseValues.decode(String.self, forKey: .terms)
//        totalCount = try albumResponseValues.decode(Int.self, forKey: .totalCount)
//    }
    
    let items: [AlbumAPI]
    let terms: String?
    let totalCount: Int
}
