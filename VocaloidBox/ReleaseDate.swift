//
//  ReleaseDate.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

struct ReleaseDate: Codable{
    
    let day: Int?
    let formatted: String
    let isEmpty: Bool
    let month: Int?
    let year: Int?
}
