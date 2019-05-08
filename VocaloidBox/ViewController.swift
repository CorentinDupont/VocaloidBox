//
//  ViewController.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var musics = [Music]()
    
    
    //MARK: Properties
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var musicTableView: UITableView!
    
    /*
     This value is either passed by `AlbumTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new album.
     */
    var album: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set up fields if there is an existing album
        if let album = album {
            authorLabel.text = album.author
            albumImage.image = album.image
            navigationItem.title = album.title
        }
        
        // load sample musics
//        loadSampleMusics()
        
        // load album musics
        loadAlbumMusics()
    }
    
    // MARK - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MusicTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MusicTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let music = musics[indexPath.row]
        cell.musicTitleLabel.text = music.title
        
        return cell
    }
    
    // MARK - private functions

    private func loadSampleMusics() {
        
        for _ in 1...3 {
            guard let music = Music(title: "music name") else {
                fatalError("Can't create sample music")
            }
            musics += [music]
        }
        
    }
    
    private func loadAlbumMusics() {
        musics = album?.musics ?? [Music]()
    }

    
    
    
}

