//
//  Music.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

class Music{
    
    // MARK: Properties
    
    var title: String
    
    // MARK: Initialization
    
    init?(title: String){
        
        //Guards
        guard !title.isEmpty else {
            return nil
        }
        
        self.title = title
    }
}
