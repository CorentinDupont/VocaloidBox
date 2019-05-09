//
//  Music.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation
import os.log

class Music : NSObject, NSCoding {
    
    // MARK: Properties
    
    var title: String
    
    // MARK: Types
    
    struct PropertyKey {
        static let title = "title"
    }
    
    // MARK: Initialization
    
    init?(title: String){
        
        //Guards
        guard !title.isEmpty else {
            return nil
        }
        
        self.title = title
    }
    
    // MARK: NSCoding
    
    // Encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
    }
    
    // Decode
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Music object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(title: title)
    }
}
