//
//  AppDelegate.swift
//  Spotify
//
//  Created by Lucas Backert on 02.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//

import Cocoa
import NotificationCenter

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var controller = NCWidgetController.widgetController()
    let commands : [String: () -> Void] = [
        SpotifyCommands.play: SpotifyApi.toPlayPause,
        SpotifyCommands.next: SpotifyApi.toNextTrack,
        SpotifyCommands.prev: SpotifyApi.toPreviousTrack,
        SpotifyCommands.open: SpotifyApi.openSpotify
    ]
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let app: [NSRunningApplication] = NSRunningApplication.runningApplications(withBundleIdentifier: "com.spotify.client") as [NSRunningApplication]
        if app.isEmpty {
            controller.setHasContent(false, forWidgetWithBundleIdentifier: "backert.SpotifyMain.SpotifyMain4Me")
        }
        
        let a = DataManager.instance
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        controller.setHasContent(true, forWidgetWithBundleIdentifier: "backert.SpotifyMain.SpotifyMain4Me")
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        if (urls.count == 1 && urls[0].pathComponents.count == 2){
            let command = urls[0].pathComponents[1]
            if ((commands[command]) != nil){
                commands[command]!();
                DataManager.instance.update()
            }
        }
    }
}

