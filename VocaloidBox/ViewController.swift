//
//  ViewController.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import UIKit
import os.log
import YoutubePlayer_in_WKWebView

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var musics = [Music]()
    
    
    //MARK: Properties
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var tableView: UITableView!
    
    
    /*
     This value is either passed by `AlbumTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new album.
     */
    var album: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //set up fields if there is an existing album
        if let album = album {
            authorLabel.text = album.author
            albumImage.image = album.image
            navigationItem.title = album.title
            
            // check if this album is already in favorite
            checkIsFavorite(album)
        }
        
        
        
        // load sample musics
//        loadSampleMusics()
        
        // load album musics
        loadAlbumMusics()
    }
    
    
    
    // MARK: Actions
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
        // First, get all albums from the local storage
        var albumsToSave: [Album]? = Album.loadAlbums()
        
        // Add the new one
        if (albumsToSave?.append(album!)) == nil {
            albumsToSave = [album!]
        }
        
        // Save the new array
        Album.saveAlbums(albums: albumsToSave!)
        
        switchFavButtonFunc(true)
    }
    
    @IBAction func removeFromFavorite(_ sender: UIBarButtonItem) {
        print("[ViewController] - remove from favorite ...")
        
        // First, get all albums from the local storage
        var albumsToSave: [Album]? = Album.loadAlbums()
        
        // remove the concerned album
        if let index = albumsToSave?.firstIndex(where: { $0.title == album?.title}) {
            albumsToSave!.remove(at: index)
            Album.saveAlbums(albums: albumsToSave!)
            
            // Change favorite button state
            switchFavButtonFunc(false)
        }
    }
    
    // MARK: Table View Methods
    
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
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MusicTableViewCell
        
        print("[ViewController] - click on cell")
        
        loadSong(withId: musics[indexPath.row].id)
    }
    
    
    // MARK: private functions
    
    private func loadSong(withId id: Int) {
        MusicServiceAPI.shared.findOne(byId: id, result: {
            (result: Result<DetailedSongAPI, MusicServiceAPI.APIServiceError>) in
            switch result {
                
            case .success(let detailedSongAPI):
                print("[AlbumTableViewController] - Received song from API !")
                
                if detailedSongAPI.pvServices.contains("Youtube") {
                    var pvId: String?
                    let searchValue = "Youtube"
                    
                    for pv in detailedSongAPI.pvs {
                        if pv.service == searchValue {
                            pvId = pv.pvId
                            break;
                            
                        }
                    }
                    
                    // Refresh the list
                    DispatchQueue.main.async {
                        print("[ViewController] - End Displaying PV ")
                        if pvId != nil { self.playerView.load(withVideoId: pvId!) }
                    }
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

    private func loadSampleMusics() {
        
        for i in 1...3 {
            guard let music = Music(id: i, title: "music name") else {
                fatalError("Can't create sample music")
            }
            musics += [music]
        }
        
    }
    
    private func loadAlbumMusics() {
        musics = album?.musics ?? [Music]()
    }

    private func checkIsFavorite(_ album: Album) {
        let loadedAlbums = Album.loadAlbums()
        print("[ViewController] - Check if this is a favorite album")
        
        if let _ = loadedAlbums?.firstIndex(where: { $0.title == album.title}) {
            switchFavButtonFunc(true)
        }
    }
    
    private func switchFavButtonFunc(_ isFavorite: Bool) {
        if isFavorite {
            print("[ViewController] - switch favorite mode to 'remove'")
            self.navigationItem.rightBarButtonItem?.title = "Remove from favorite"
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem?.action = #selector(self.removeFromFavorite)
        } else {
            print("[ViewController] - switch favorite mode to 'add'")
            self.navigationItem.rightBarButtonItem?.title = "Add to favorite"
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
            self.navigationItem.rightBarButtonItem?.action = #selector(self.addToFavorite)
        }
    }
    
}

