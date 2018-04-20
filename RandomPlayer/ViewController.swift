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
    
    var tableView: UITableView!
    var playerView: UIView!
    var playToggleButton : UIButton!
    let playImage: UIImage! = #imageLiteral(resourceName: "icons8-circled-play-50")
    let pauseImage: UIImage! = #imageLiteral(resourceName: "icons8-pause-button-50")
    let shuffleImage: UIImage! = #imageLiteral(resourceName: "icons8-shuffle-50")
    var songLabel : UILabel!
    
    var albumList: [MPMediaItemCollection] = []
    var playlistList: [MPMediaItemCollection] = []
    var songList: [MPMediaItem] = []
    
    var currentListType: ListType = .song
    var currentTrack: MPMediaItem!
    let myMediaPlayer = MPMusicPlayerController.applicationMusicPlayer

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        albumList = MediaQuery.getAlbums()
        songList = MediaQuery.getSongs()
        playlistList = MediaQuery.getPlaylists()

        setupPlayerView()
        chooseRandomTrack()
        updatePlayerView()
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaCell")
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.darkGray
        tableView.backgroundColor = UIColor.darkGray
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(playerView.snp.bottom).offset(1.0)
            make.height.equalTo(view.snp.height).dividedBy(4.0/3.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupPlayerView() {
        playerView = UIView()
        playerView.backgroundColor = .lightGray
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(5)
        }
        songLabel = UILabel()
        songLabel.textAlignment = .center
        playerView.addSubview(songLabel)
        songLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        playToggleButton = UIButton()
        playToggleButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        playToggleButton.setImage(playImage, for: .normal)
        playerView.addSubview(playToggleButton)
        playToggleButton.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(playToggleButton.snp.height)
            make.centerX.equalToSuperview().offset(40)
        }
        let randomButton = UIButton()
        randomButton.addTarget(self, action: #selector(playRandom), for: .touchUpInside)
        playerView.addSubview(randomButton)
        randomButton.setImage(shuffleImage, for: .normal)
        randomButton.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview().offset(-40)
        }
    }
    
    func updatePlayerView() {
        songLabel.text = currentTrack.title
    }
    
    func chooseRandomTrack() {
        let random = arc4random_uniform(UInt32(songList.count))
        currentTrack = songList[Int(random)]
    }
    
    //Functions for setting up and managing TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentListType {
        case .song:
            return songList.count
        case .album:
            return albumList.count
        case .playlist:
            return playlistList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        let song = songList[indexPath.row]
        cell.textLabel?.text = song.value(forProperty: MPMediaItemPropertyTitle) as? String
        cell.selectionStyle = .default
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTrack = songList[indexPath.row]
        playToggleButton.setImage(pauseImage, for: .normal)
        updatePlayerView()
        playSong()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Functions for managing media player
    @objc func togglePlay() {
        if(myMediaPlayer.playbackState == .playing) {
            myMediaPlayer.pause()
            playToggleButton.setImage(playImage, for: .normal)
        } else {
            if(myMediaPlayer.playbackState == .paused) {
                myMediaPlayer.play()
            } else {
                playSong()
            }
            playToggleButton.setImage(pauseImage, for: .normal)
        }
    }
    
    @objc func playRandom() {
        chooseRandomTrack()
        playToggleButton.setImage(pauseImage, for: .normal)
        updatePlayerView()
        playSong()
    }
    
    func playSong() {
        myMediaPlayer.stop()
        // Add a playback queue containing the song to be played
        let trackQueue = MPMediaItemCollection(items: [currentTrack])
        myMediaPlayer.setQueue(with: trackQueue)
        myMediaPlayer.prepareToPlay()
        if(myMediaPlayer.isPreparedToPlay) {
            // Start playing
            myMediaPlayer.play()
        }
    }

}

