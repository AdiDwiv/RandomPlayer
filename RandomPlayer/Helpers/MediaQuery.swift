//
//  MediaQuery.swift
//  RandomPlayer
//
//  Created by Aditya Dwivedi on 4/20/18.
//  Copyright © 2018 Aditya Dwivedi. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaQuery {
    class func getSongs() ->  [MPMediaItem] {
        let mySongQuery = MPMediaQuery.songs()
        if let songs = mySongQuery.items {
            return songs
        }
        return []
    }
    class func getAlbums() ->  [MPMediaItemCollection] {
        let myAlbumQuery = MPMediaQuery.albums()
        if let albums = myAlbumQuery.collections {
            return albums
        }
        return []
    }
    
    class func getPlaylists() ->  [MPMediaItemCollection]{
        let myPlaylistQuery = MPMediaQuery.playlists()
        if let playlists = myPlaylistQuery.collections {
            return playlists
        }
        return []
    }
}
