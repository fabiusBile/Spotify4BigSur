//
//  DataManager.swift
//  SpotifyMain
//
//  Created by Lucas Backert on 05.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//

import Foundation
import AppKit
import NotificationCenter
import WidgetKit

class DataManager {
    static let instance : DataManager = DataManager()
    
    
    let smState = "smState"
    let smTitle = "smTitle"
    let smAlbum = "smAlbum"
    let smArtist = "smArtist"
    let smCover = "smCover"
    let smVolume = "smVolume"
    
    var defaults = UserDefaults(suiteName: "backert.apps")!
    var centerReceiver = DistributedNotificationCenter()
    var information: [String:Any] = [:]
    private init(){
        _ = centerReceiver.addObserver(forName: NSNotification.Name(rawValue: "Spotify4Me"), object: nil, queue: nil) { (note) -> Void in
            var defaultcase = false
            let cmd = note.object as! String
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
                break
            case let volumestring :
                if let range = volumestring.range(of: "volume") {
                    let stringVol:String = volumestring.substring(from: range.upperBound)
                    self.volume(level: Int(stringVol)!)
                }
            }
            if !defaultcase {
                let notify = NSNotification(name: NSNotification.Name(rawValue: "Spotify4Me"), object: "finished")
                self.centerReceiver.post(notify as Notification)
            }
            
        }
        
        let spotifyObserver = self.centerReceiver.addObserver(forName: NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { (note) -> Void in
            let info = note.userInfo!
            let state = info["Player State"]! as! String
            
            _ = NSNotification(name: NSNotification.Name(rawValue: "Spotify4Me"), object: "update")
            var mainapp: [NSRunningApplication] = NSRunningApplication.runningApplications(withBundleIdentifier: "backert.SpotifyMain") as [NSRunningApplication]
            
            let controller = NCWidgetController.widgetController()
            
            if state == "Stopped" {
                controller.setHasContent(false, forWidgetWithBundleIdentifier: "backert.SpotifyMain.SpotifyMain4Me")
            }else{
                controller.setHasContent(true, forWidgetWithBundleIdentifier: "backert.SpotifyMain.SpotifyMain4Me")
            }
            
            self.update()
        }
    }
    public static func updateWidget() {
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "SpotifyWidget")
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
        defaults.setPersistentDomain(information, forName: "backert.apps")
        defaults.synchronize()
        DataManager.updateWidget()
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
        SpotifyApi.setVolume(level: level)
        update()
    }
}
