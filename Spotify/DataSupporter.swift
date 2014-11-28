//
//  DataSupporter.swift
//  Spotify
//
//  Created by Lucas Backert on 02.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//
import Foundation
struct SpotifyApi {
    static let osaStart = "tell application \"Spotify\" to"
    
    static func getState() ->String{
        return executeScript("player state")
    }

    static func getTitle() -> String{
        return executeScript("name of current track")
    }
    
    static func getAlbum() -> String{
        return executeScript("album of current track")
    }
    
    static func getArtist() -> String{
        return executeScript("artist of current track")
    }
    
    static func getCover() -> NSData{
        var result: NSData = NSData()
        let script = NSAppleScript(source: "\(osaStart) artwork of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        if(descriptor != nil){
            result = descriptor!.data
        }
        return result
    }
    
    static func getVolume() -> String{
        return executeScript("sound volume")
    }
    
    static func setVolume(level: Int){
        executeScript("set sound volume to \(level)")
    }
    
    static func toNextTrack(){
        executeScript("next track")
    }
    
    static func toPreviousTrack(){
        executeScript("previous track")
    }
    
    static func toPlayPause(){
        executeScript("playpause")
    }
    
    static func executeScript(phrase: String) -> String{
        var output = ""
        let script = NSAppleScript(source: "\(osaStart) \(phrase)" )
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        //println("err: getState \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            output = descriptor!.stringValue!
            //println("descriptor: \(descriptor!))")
        }
        return output
    }
    
    // NOT USED AT THE MOMENT
    static func getDuration() -> String{
        return executeScript("duration of current track")
    }
    
    static func getPosition() -> String{
        return executeScript("position of current track")
    }
}

