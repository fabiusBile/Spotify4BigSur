//
//  TodayViewController.swift
//  Spotify4Me
//
//  Created by Lucas Backert on 02.11.14.
//  Copyright (c) 2014 Lucas Backert. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    let smState = "smState"
    let smTitle = "smTitle"
    let smAlbum = "smAlbum"
    let smArtist = "smArtist"
    let smCover = "smCover"
    let smVolume = "smVolume"
    let playImage = NSImage(named:  NSImage.Name("play"))
    let pauseImage = NSImage(named: NSImage.Name("pause"))

    var initialize = true
    var defaults = UserDefaults(suiteName: "backert.apps")!
    var centerReceiver = DistributedNotificationCenter()
    var information = [String:Any]()
    var controller = NCWidgetController.widgetController()
    
    @IBOutlet weak var titleOutput: NSTextField!
    @IBOutlet weak var albumOutput: NSTextField!
    @IBOutlet weak var artistOutput: NSTextField!
    @IBOutlet weak var coverOutput: NSImageView!
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var playpauseButton: NSButton!
    
    @IBAction func volumeSliderAction(sender: AnyObject) {
        let notify = Notification(name: NSNotification.Name("Spotify4Me"), object: "volume\(sender.integerValue)")
        centerReceiver.post(notify)
    }
    @IBAction func previousButton(sender: AnyObject) {
        let notify = Notification(name: NSNotification.Name ("Spotify4Me"), object: "back")
        centerReceiver.post(notify)
    }
    @IBAction func nextButton(sender: AnyObject) {
        let notify = Notification(name: NSNotification.Name ("Spotify4Me"), object: "skip")
        centerReceiver.post(notify)
    }
    @IBAction func playpauseButton(sender: AnyObject) {
        let notify = Notification(name: NSNotification.Name ("Spotify4Me"), object: "playpause")
        centerReceiver.post(notify)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        if initialize {
            setReceiver()
            let notify = Notification(name: Notification.Name ("Spotify4Me"), object: "update")
            var mainapp = NSRunningApplication.runningApplications(withBundleIdentifier: "backert.SpotifyMain")
            if mainapp.isEmpty {
                titleOutput.stringValue = "Please start 'SpotifyMain' application"
            }else {
                var app = NSRunningApplication.runningApplications(withBundleIdentifier: "com.spotify.client")
                if app.isEmpty {
                    controller.setHasContent(false, forWidgetWithBundleIdentifier: "backert.SpotifyMain.SpotifyMain4Me")
                }else{
                    centerReceiver.post(notify)
                }
            }
        }
        completionHandler(.newData)
    }

    func setReceiver(){
        initialize = false
        let homeAppObserver = self.centerReceiver.addObserver( forName: NSNotification.Name(rawValue: "Spotify4Me"), object: nil, queue: nil) { (note) -> Void in
            let cmd = note.object as! String
            if cmd == "finished" {
                self.information = self.defaults.persistentDomain(forName: "backert.apps")!
                self.refreshView()
            }
        }
        let spotifyObserver = self.centerReceiver.addObserver(forName: Notification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { (note) -> Void in
            let info = note.userInfo!
            let state = info["Player State"]! as! String
            let notify = Notification(name: Notification.Name(rawValue: "Spotify4Me"), object: "update")
            
            var mainapp: [NSRunningApplication] = NSRunningApplication.runningApplications(withBundleIdentifier: "backert.SpotifyMain") as [NSRunningApplication]
            if mainapp.isEmpty {
                self.titleOutput.stringValue = "Please start 'SpotifyMain' application"
            }else {
                if state != "Stopped" {
                    self.centerReceiver.post(notify as Notification)
                }
            }
        }
    }
    
    func refreshView(){
        
        titleOutput.stringValue = information[smTitle] as! String
        albumOutput.stringValue = information[smAlbum] as! String
        artistOutput.stringValue = information[smArtist] as! String
        let vol: String = information[smVolume] as! String
        volumeSlider.integerValue = Int(vol)!
        let coverAsData = information[smCover] as! NSData
        coverOutput.image = NSImage(data: coverAsData as Data)
        let state = information[smState] as! String
        if state == "kPSP" {
            playpauseButton.image = pauseImage
        }else if state == "kPSp" {
            playpauseButton.image = playImage
        }
    }
}
