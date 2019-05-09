//
//  Album.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Album : NSObject, NSCoding {
    
    // MARK: Properties
    
    var title: String
    var image: UIImage?
    var author: String
    var musics: Array<Music>?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("albums")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let image = "image"
        static let author = "author"
        static let musicCount = "musicCount"
    }
    
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
    
    //MARK: NSCoding
    
    // Encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(author, forKey: PropertyKey.author)
        
        // register the musics count
        aCoder.encode(musics?.count ?? 0, forKey: PropertyKey.musicCount)
        
        //register items of musics array independently
        for i in 0 ..< musics!.count {
            aCoder.encode( musics![ i ] )
        }
    }
    
    // Decode
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for an Album object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because image is an optional property of Album, just use conditional cast.
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        // Decode required field author
        guard let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String else {
            os_log("Unable to decode the author for an Album object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // decode the musics count
        let musicCount = aDecoder.decodeInteger(forKey: PropertyKey.musicCount)
        var musics = [Music]()
        
        for _ in 0 ..< musicCount {
            if let music = aDecoder.decodeObject() as? Music {
                musics.append(music)
            }
        }
        
        // Must call designated initializer.
        self.init(title: title, image: image, author: author, musics: musics)
    }
    
    // Save all to local storage
    static func saveAlbums(albums: [Album]) {
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: albums, requiringSecureCoding: false)
            try data.write(to: Album.ArchiveURL)
            os_log("Albums successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save albums...", log: OSLog.default, type: .error)
        }
    }
    
    // get the Documents Directory
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Load all from the local storage
    static func loadAlbums() -> [Album]? {
        let fullPath = Album.getDocumentsDirectory().appendingPathComponent("albums")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedAlbums = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Album> {
                    return loadedAlbums
                }
            } catch let error {
                print(error)
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}
