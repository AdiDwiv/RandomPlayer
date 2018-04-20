//
//  ViewController.swift
//  RandomPlayer
//
//  Created by Aditya Dwivedi on 4/20/18.
//  Copyright © 2018 Aditya Dwivedi. All rights reserved.
//

import UIKit
import SnapKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    //Views that require global references
    var tableView: UITableView!
    var playerView: UIView!
    var playToggleButton : UIButton!
    let playImage: UIImage! = #imageLiteral(resourceName: "icons8-play-48")
    let pauseImage: UIImage! = #imageLiteral(resourceName: "icons8-pause-48")
    let shuffleImage: UIImage! = #imageLiteral(resourceName: "icons8-shuffle-48")
    var songLabel : UILabel!
    
    //Populator list for table view
    var songList: [MPMediaItem] = []
    //Current track
    var currentTrack: MPMediaItem!
    //Bool whether media player has played a song in this instance of the class
    var hasPlayedSong: Bool = false
    //Media player instance
    let mediaPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    //Layout constants for snapkit
    let standardOffest: CGFloat = 15

    //Sets up views and calls data populators
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .noir
        title = "Random Player"
        songList = MediaQuery.getSongs()
        
        //instantiates the player view
        setupPlayerView()
        if(songList.count <= 0) {
            //Alert for empty music libraries- will fire for simulators
            let alert = UIAlertController(title: "Error", message: "Could not find any songs on device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        } else {
            chooseRandomTrack()
            updatePlayerView()
            mediaPlayer.stop()
        }
        
        //instantiates tableview
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaCell")
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.darkGray
        tableView.backgroundColor = .matins
        tableView.separatorColor = .noir
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(playerView.snp.bottom).offset(1.0)
            make.height.equalTo(view.snp.height).dividedBy(4.0/3.0)
        }
    }
    
    //Sets up the player view containing song tile, play and random buttons
    func setupPlayerView() {
        playerView = UIView()
        playerView.backgroundColor = .midnightPurple
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(5.5)
        }
        songLabel = UILabel()
        songLabel.textAlignment = .center
        songLabel.backgroundColor = .clear
        songLabel.layer.masksToBounds = true
        songLabel.layer.cornerRadius = 5
        songLabel.textColor = .roseLitest
        playerView.addSubview(songLabel)
        songLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalToSuperview().dividedBy(1.5)
            make.centerX.equalToSuperview()
        }
        playToggleButton = UIButton()
        playToggleButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        playToggleButton.setImage(playImage, for: .normal)
        playToggleButton.layer.borderWidth = 2.0
        playToggleButton.layer.borderColor = UIColor.rose.cgColor
        playToggleButton.layer.cornerRadius = 16
        playerView.addSubview(playToggleButton)
        playToggleButton.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(standardOffest)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(playToggleButton.snp.height)
            make.centerX.equalToSuperview().offset(standardOffest*3)
        }
        let randomButton = UIButton()
        randomButton.addTarget(self, action: #selector(playRandom), for: .touchUpInside)
        playerView.addSubview(randomButton)
        randomButton.setImage(shuffleImage, for: .normal)
        randomButton.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(standardOffest)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview().offset(-standardOffest*3)
        }
    }
    
    //Updates player view's label in accordance with new track
    func updatePlayerView() {
        songLabel.text = currentTrack.title
    }
    
    //assigns random track to currenttrack
    func chooseRandomTrack() {
        let random = arc4random_uniform(UInt32(songList.count))
        currentTrack = songList[Int(random)]
    }
    
    //Functions for setting up and managing TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        let song = songList[indexPath.row]
        cell.textLabel?.text = song.value(forProperty: MPMediaItemPropertyTitle) as? String
        cell.selectionStyle = .default
        cell.backgroundColor = .matins
        cell.textLabel?.textColor = .roseLite
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTrack = songList[indexPath.row]
        playToggleButton.setImage(pauseImage, for: .normal)
        updatePlayerView()
        hasPlayedSong = true
        playSong()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Functions for managing media player
    
    //Toggles between play and pause
    @objc func togglePlay() {
        if(mediaPlayer.playbackState == .playing) {
            mediaPlayer.pause()
            playToggleButton.setImage(playImage, for: .normal)
        } else {
            if(hasPlayedSong) {
                mediaPlayer.play()
            } else {
                hasPlayedSong = true
                playSong()
            }
            playToggleButton.setImage(pauseImage, for: .normal)
        }
    }
    
    //Chooses and then plays a random track
    @objc func playRandom() {
        chooseRandomTrack()
        playToggleButton.setImage(pauseImage, for: .normal)
        updatePlayerView()
        playSong()
    }
    
    //Plays the current track
    func playSong() {
        mediaPlayer.stop()
        // Creates a playback queue containing the current track
        let trackQueue = MPMediaItemCollection(items: [currentTrack])
        mediaPlayer.setQueue(with: trackQueue)
        mediaPlayer.prepareToPlay()
        if(mediaPlayer.isPreparedToPlay) {
            // Start playing
            mediaPlayer.play()
        }
    }

}

