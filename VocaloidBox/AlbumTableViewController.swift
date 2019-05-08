//
//  AlbumTableViewController.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import UIKit
import os.log

class AlbumTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var albums = [Album]()
    var desiredAlbumCount = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAlbumsFromAPI(from: 0)
        
        //load samples albums
//        loadSampleAlbums()
        
        //load albums from API
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AlbumTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbumTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AlbumTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let album = albums[indexPath.row]
        cell.albumNameLabel.text = album.title
        cell.albumImage.image = album.image
        cell.albumAuthorLabel.text = album.author
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK - Infinite Scroll
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("[AlbumTableViewController] - Try to load more content ... ", albums.count, desiredAlbumCount, indexPath.row)
        if albums.count == desiredAlbumCount && indexPath.row == albums.count-1 {
            // load more albums
            loadAlbumsFromAPI(from: albums.count)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new album.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let albumDetailViewController = segue.destination as? ViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedAlbumCell = sender as? AlbumTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedAlbumCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedAlbum = albums[indexPath.row]
                albumDetailViewController.album = selectedAlbum
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
 

    //MARK: Private Methods
    
    private func loadSampleAlbums() {
        let photo1 = UIImage(named: "DefaultAlbumImage")
        
        guard let album1 = Album(title: "Beautiful Stars", image: photo1, author: "Foglol", musics: [Music]()) else {
            fatalError("Unable to instantiate album1")
        }
        
        guard let album2 = Album(title: "Great Magical World", image: photo1, author: "Foglol", musics: [Music]()) else {
            fatalError("Unable to instantiate album2")
        }
        
        guard let album3 = Album(title: "Light Over The Rainbow", image: photo1, author: "Foglol", musics: [Music]()) else {
            fatalError("Unable to instantiate album3")
        }
        
        albums += [album1, album2, album3]
        
    }
    
    private func loadAlbumsFromAPI(from start: Int) {
        
        print("[AlbumTableViewController] - Load albums from API")
        
        desiredAlbumCount += 10
        
        // Call the API to get AlbumAPI objects
        AlbumServiceAPI.shared.fetchAlbums(from: start) {
            (result: Result<AlbumsResponse, AlbumServiceAPI.APIServiceError>) in
            switch result {
            case .success(let albumResponse):
            
                print("[AlbumTableViewController] - Received Data from API ! ")
                
                let albumsAPI: [AlbumAPI] = albumResponse.items
                
                // itterate on albumsAPI array to create relative Album object, wich are displayed to the front.
                for albumAPI in albumsAPI {
                    
                    // get the image corresponding to the url. Get a default image when url is empty
                    
                    let imageUrl = URL(string: albumAPI.mainPicture?.urlThumb ?? "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAOVBMVEXz9Pa5vsq2u8jN0dnV2N/o6u7w8fTi5OnFydO+ws3f4ee6v8vY2+H29/jy9Pbu7/LJztbCx9HR1ty/NMEIAAAC8ElEQVR4nO3b67ZrMBiFYaSh1HHd/8XuFap1SFolXb7s8T4/18EwOyNCiSIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACryrezAy2kulR+lVl6dqip7Jr412Zyeizj7yjODjYqvhRQTMQm/1rC/OxsvapIht3xehDeN1lIOBSrtt+ZW+t1Kh02GrciEvaDNLl4Ph1e+hqvEk4Z94SZ580WchJGJNyHhH/JlrDR+uC+iU6Yqf7c2JXNga0KTlj/xOP5ujuwdpabML0mz1VXUu7eqtyEP5OAvysdvXerYhMWs4C/a+e9uyg1YXVdXh7sXTtLTagXFcaJ2rlVqQmXgzSOu5f76J5shSasylXC/NVJUbknW6kJLx8lNPNu6WhRaMKPRmmtzB+7WpSasNk+09TjmdPeotSEVbfs0HW7LFXjh2FvUWrC1Z1F1yCt1aRtW4tiE0ZqPk4dp4NUzYaypUW5CaNuGtExjdSLz8HSouCEjRqvnuLcceE/b9D+UQhOGFWZys093e7S2IfoqkFbi5ITRv1NDN24ds7SoKVF4QlfsTa4bjHchOmPI+AiYrgJXQ0uB2qoCWt3g4sWQ034qsF5i4EkbBY3ol43OGsxjIT6luvp7NG+DfhsMYSElc7jpHteAL85BhcthpBQ38zPny1uadD8x3C9JT+habD/RXdfu21rsP822fy5/IR9g/GjxXpjg+ZSKoiEY4OPFrc2GEzCR4O9XL87D4aWcNrgEHFzvkASzhv8UAAJVw3+dwkPNRhAwoMNBpDwYIPiEx5uUHzCww1KT1htX7qEmnD9/SEJSXhutgEJSUjC8/lOKPs+jfla7ajh/qPUhP6Q8C+RcJdKUML7W0HK75vA9+/hrmenM8bHgr/y7pqS8O7a43nEb7x/6Pvo3iddPa3njYx3SKMoO37rwu4mo8LIPJB4fLG2lggZoz3d5l6PQuPWahHTzEgXF79KQQUCAAAAAAAAAAAAAAAAAAAAAAAAAAAAp/gHLTI30QIHnooAAAAASUVORK5CYII=")!
                    let imageData = try! Data(contentsOf: imageUrl)
                    let image = UIImage(data: imageData)
                    
                    // transform all tracks in Music objects
                    var albumMusics = [Music]()
                    
                    for track in albumAPI.tracks {
                        guard let music = Music(title: track.name) else {
                            fatalError("Unable to instantiate music " + track.name)
                        }
                        albumMusics += [music]
                    }
                    
                    // Create the album object
                    guard let album = Album(title: albumAPI.name, image: image, author: albumAPI.artistString, musics: albumMusics) else {
                        fatalError("Unable to instantiate album " + albumAPI.name)
                    }
                    
                    // Add the created album to the album array
                    self.albums += [album]
                    
                    // Refresh the list
                    DispatchQueue.main.async {
                        print("[AlbumTableViewController] - End displaying new albums. ")
                        self.tableView.reloadData()
                    }
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}

//extension AlbumTableViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//    }
//}
//
//private extension AlbumTableViewController {
//    func isLoadingCell(for indexPath: IndexPath) -> Bool {
//        return indexPath.row >= viewModel.currentCount
//    }
//
//    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
//        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
//        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
//        return Array(indexPathsIntersection)
//    }
//}
