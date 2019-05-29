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
    
    var id: Int
    var title: String
    
    // MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let id = "id"
    }
    
    // MARK: Initialization
    
    init?(id: Int, title: String){
        
        //Guards
        guard !title.isEmpty else {
            return nil
        }
        
        self.title = title
        self.id = id
    }
    
    // MARK: NSCoding
    
    // Encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
    // Decode
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Music object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let id = aDecoder.decodeInteger(forKey: PropertyKey.id) as? Int else {
            os_log("Unable to decode the id for a Music object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(id: id, title: title)
    }
}
