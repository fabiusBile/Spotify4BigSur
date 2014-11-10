//
//  DataManager.swift
//  SpotifyMain
//
//  Created by Lucas Backert on 05.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//

import Foundation
import AppKit

class DataManager {
    let smState = "smState"
    let smTitle = "smTitle"
    let smAlbum = "smAlbum"
    let smArtist = "smArtist"
    let smCover = "smCover"
    let smVolume = "smVolume"
    
    var defaults = NSUserDefaults(suiteName: "backert.apps")!
    var centerReceiver = NSDistributedNotificationCenter()
    var information: [String:AnyObject] = [:]
    init(){
        var observer = centerReceiver.addObserverForName("Spotify4Me", object: nil, queue: nil) { (note) -> Void in
            println( "received in app \(note.object as String)")
            var defaultcase = false
            let cmd = note.object as String
            switch cmd {
            case "update":
                self.update()
            case "playpause":
                self.playpause()
            case "skip":
                self.skip()
            case "back":
                self.back()
            case "finished":
                defaultcase = true
                println("been in finished case!")
                break
            case let volumestring :
                println("vol mes: \(volumestring)")
                if let range = volumestring.rangeOfString("volume") {
                    let stringVol:String = volumestring.substringFromIndex(range.endIndex)
                    self.volume(stringVol.toInt()!)
                }
            default:
                defaultcase = true
                println("been in default case!")
            }
            if !defaultcase {
                let notify = NSNotification(name: "Spotify4Me", object: "finished")
                self.centerReceiver.postNotification(notify)
            }
            
        }
    }
    func update(){
        
        let state = SpotifyApi.getState()
        information.updateValue(state, forKey: smState)
        if state != "kPSS" {
            information.updateValue(SpotifyApi.getTitle(), forKey: smTitle)
            information.updateValue(SpotifyApi.getAlbum(), forKey: smAlbum)
            information.updateValue(SpotifyApi.getArtist(), forKey: smArtist)
            information.updateValue(SpotifyApi.getCover(), forKey: smCover)
            information.updateValue(SpotifyApi.getVolume(), forKey: smVolume)
        }
        save()
    }
    func playpause(){
        SpotifyApi.toPlayPause()
        update()
    }
    func skip(){
        SpotifyApi.toNextTrack()
        update()
    }
    func back(){
        SpotifyApi.toPreviousTrack()
        update()
    }
    func volume(level: Int){
        SpotifyApi.setVolume(level)
        update()
    }
    func save(){
        defaults.setPersistentDomain(information, forName: "backert.apps")
        defaults.synchronize()
    }
}