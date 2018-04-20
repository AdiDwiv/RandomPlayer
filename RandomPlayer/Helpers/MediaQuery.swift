//
//  MediaQuery.swift
//  RandomPlayer
//
//  Created by Aditya Dwivedi on 4/20/18.
//  Copyright © 2018 Aditya Dwivedi. All rights reserved.
//
// Class functions make queries to the user's Media library

import Foundation
import MediaPlayer

class MediaQuery {
    
    //Gets all songs from the user's library
    class func getSongs() ->  [MPMediaItem] {
        let mySongQuery = MPMediaQuery.songs()
        if let songs = mySongQuery.items {
            return songs
        }
        return []
    }
    
    //Gets all albums from the user's library
    class func getAlbums() ->  [MPMediaItemCollection] {
        let myAlbumQuery = MPMediaQuery.albums()
        if let albums = myAlbumQuery.collections {
            return albums
        }
        return []
    }
    
    //Gets all playlists from the user's library
    class func getPlaylists() ->  [MPMediaItemCollection]{
        let myPlaylistQuery = MPMediaQuery.playlists()
        if let playlists = myPlaylistQuery.collections {
            return playlists
        }
        return []
    }
}
