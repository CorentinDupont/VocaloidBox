//
//  ImportNewAlbumViewController.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 03/06/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ImportNewAlbumViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var importButton: UIBarButtonItem!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var mediaItems = [MPMediaItem]()
    var mpMediapicker: MPMediaPickerController!
    var avMusicPlayer = AVAudioPlayer()
    let currentIndex = 0
    var musicPlayer: MPMusicPlayerController?
    var audioPlayer: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Setting up.")
        
//        do {
//            let audioPath = Bundle.main.path(forResource: "mantastorm", ofType: "wav")
//            try avAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
//
//        } catch {
//            print("error")
//        }
        
        // If you'd rather not use this sound file,
        // replace the string below with the URL of some other MP3.
//        let urlString = "http://www.stephaniequinn.com/Music/Pachelbel%20-%20Canon%20in%20D%20Major.mp3"
//        let url = NSURL(string: urlString)!
//        avPlayer = AVPlayer(url: url as URL)
        
        let url = URL.init(fileURLWithPath: Bundle.main.path(
            forResource: "mantastorm",
            ofType: "wav")!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
        

        // Do any additional setup after loading the view.
        importButton.isEnabled = false
        
        // Handle the text field’s user input through delegate callbacks.
        albumNameTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        albumNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        //completion is a callback function.
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func loadSongs(_ sender: Any) {
        // set media type to songs
        mpMediapicker = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        
        // allow multiple items picking
        mpMediapicker.allowsPickingMultipleItems = false
        
        // delegate the functions
        mpMediapicker.delegate = self
        
        // show the media picker
        self.present(mpMediapicker, animated: true, completion: nil)

    }
    
    @IBAction func playAudio(_ sender: AnyObject) {
        if let player = audioPlayer {
            player.play()
        } else {
            print("NANI THE FUCK")
        }
    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        if let player = audioPlayer {
            player.stop()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkImportPossibility()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        importButton.isEnabled = false
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        albumImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        // check import possibility
        checkImportPossibility()
    }
    
    // MARK: - MPMediaPickerControllerDelegate
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaItems = mediaItemCollection.items
        
        updatePlayer()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    
    private func checkImportPossibility() -> Void {
        if (
            albumNameTextField.text != ""
            && albumImageView.image != UIImage(named: "Image")
        ) {
            importButton.isEnabled = true
        }
    }
    
    private func updatePlayer(){
        let item = mediaItems[currentIndex]
        // DO-TRY-CATCH try to setup AVAudioPlayer with the path, if successful, sets up the AVMusicPlayer, and song values.
        if let path: NSURL = item.assetURL as NSURL? {
            print("[ImportNewAlbumViewController] path NSURL : ", path)
            do
            {
                avMusicPlayer = try AVAudioPlayer(contentsOf: path as URL, fileTypeHint: "mp3")
                
//                avMusicPlayer.enableRate = true
//                avMusicPlayer.rate = 1.0
//                avMusicPlayer.numberOfLoops = 0
//                avMusicPlayer.currentTime = 0
            }
            catch
            {
//                avMusicPlayer = nil
                print("wtf")
            }
        }
    }

}
