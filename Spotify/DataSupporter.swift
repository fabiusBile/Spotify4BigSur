//
//  DataSupporter.swift
//  Spotify
//
//  Created by Lucas Backert on 02.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//

import Foundation
struct SpotifyApi {
    
    static func getState() ->String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to player state")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getState \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getState \(descriptor!))")
        }
        return textOutput
    }

    static func getTitle() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to name of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getTitle \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getTitle \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func getAlbum() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to album of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getAlbum \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getAlbum \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func getArtist() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to artist of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getArtist \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getArtist \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func getCover() -> NSData{
        var result: NSData = NSData()
        let script = NSAppleScript(source: "tell application \"Spotify\" to artwork of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getCover \(errorInfo?.description))")
        if(descriptor != nil){
            result = descriptor!.data
            //println("res: getCover \(descriptor!.stringValue!))")
        }
        return result
    }
    
    static func getDuration() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to duration of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getDuration \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getDuration \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func getPosition() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to duration of current track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getPosition \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getPosition \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func getVolume() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to sound volume")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: getVolume \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: getVolume \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func setVolume(level: Int){
        let script = NSAppleScript(source: "tell application \"Spotify\" to set sound volume to \(level)")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: setVolume \(errorInfo?.description))")
    }
    
    static func toNextTrack() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to next track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: toNextTrack \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: toNextTrack \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func toPreviousTrack() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to previous track")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: toPreviousTrack \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: toPreviousTrack \(descriptor!.stringValue!))")
        }
        return textOutput
    }
    
    static func toPlayPause() -> String{
        var textOutput = ""
        let script = NSAppleScript(source: "tell application \"Spotify\" to playpause")
        var errorInfo: NSDictionary?
        var descriptor = script?.executeAndReturnError(&errorInfo)
        println("err: toPlayPause \(errorInfo?.description))")
        if(descriptor?.stringValue != nil){
            textOutput = descriptor!.stringValue!
            println("res: toPlayPause \(descriptor!.stringValue!))")
        }
        return textOutput
    }
}

