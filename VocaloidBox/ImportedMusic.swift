//
//  ImportedMusic.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 03/06/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

class ImportedMusic {
    // MARK: Properties
    
    var id: String?
    var title: String
    var uri: String
    
    init(id: String?, title: String, uri: String) {
        self.id = id
        self.title = title
        self.uri = uri
    }
}
