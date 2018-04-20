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
    
    var albumList: [MPMediaItemCollection] = []
    var playlistList: [MPMediaItemCollection] = []
    var songList: [MPMediaItem] = []
    
    var currentListType: ListType = .song

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        albumList = MediaQuery.getAlbums()
        songList = MediaQuery.getSongs()
        playlistList = MediaQuery.getPlaylists()
        
        playerView = UIView()
        playerView.backgroundColor = .red
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(4)
        }
        
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
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func playSong(song: MPMediaItem) {
        // Instantiate a new music player
        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        // Add a playback queue containing all songs on the device
        myMediaPlayer.set
        myMediaPlayer.play()
        // Start playing from the beginning of the queue
        myMediaPlayer.play()
    }

}

