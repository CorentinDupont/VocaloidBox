//
//  Album.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation
import UIKit

class Album {
    
    // MARK: Properties
    
    var title: String
    var image: UIImage?
    var author: String
    var musics: Array<Music>?
    
    // MARK: Initialization
    
    init?(title: String, image: UIImage?, author: String, musics: Array<Music>?){
        
        //Test title and author
        guard !title.isEmpty && !author.isEmpty else{
            return nil
        }
        
        //Initialize stored properties
        self.title = title
        self.image = image
        self.author = author
        self.musics = musics
    }
}
