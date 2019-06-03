//
//  ImportedAlbum.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 03/06/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation


class ImportedAlbum {
    
    var name: String
    var musics: [ImportedMusic]
    
    init(name: String, musics: [ImportedMusic]) {
        self.name = name
        self.musics = musics
    }

}
