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
    let smState = "smState"
    let smTitle = "smTitle"
    let smAlbum = "smAlbum"
    let smArtist = "smArtist"
    let smCover = "smCover"
    let smVolume = "smVolume"
    let playImage = NSImage(named: "play")
    let pauseImage = NSImage(named: "pause")
    
    var spotifyStarted = false
    var isHiddenBefore = true
    var initialize = true
    var defaults = NSUserDefaults(suiteName: "backert.apps")!
    var centerReceiver = NSDistributedNotificationCenter()
    var information = [NSObject:AnyObject]()
    
    
    func setReceiver(){
        initialize = false
        let observer = self.centerReceiver.addObserverForName("Spotify4Me", object: nil, queue: nil) { (note) -> Void in
            let cmd = note.object as String
            println("received in ext \(cmd)")
            if cmd == "finished" {
                self.information = self.defaults.persistentDomainForName("backert.apps")!
                println(self.information.description)
                self.refreshView()
            }
        }
    }
    
    
    
    //let viewHeightActive = CGFloat(92)
    //let viewHeightPassive = CGFloat(30)
    let textfieldrestore = CGFloat(18)
    let coverrestore = CGFloat(75)
    let artist2refreshrestore = CGFloat(3)
    let eliminateHeight = CGFloat(0)
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var albumHeight: NSLayoutConstraint!
    @IBOutlet weak var artistHeight: NSLayoutConstraint!
    @IBOutlet weak var coverHeight: NSLayoutConstraint!
    @IBOutlet weak var artist2refreshHeight: NSLayoutConstraint!
    //@IBOutlet weak var view2refreshHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleOutput: NSTextField!
    @IBOutlet weak var albumOutput: NSTextField!
    @IBOutlet weak var artistOutput: NSTextField!
    @IBOutlet weak var coverOutput: NSImageView!
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var playpauseButton: NSButton!
    
    @IBAction func volumeSliderAction(sender: AnyObject) {
        let notify = NSNotification(name: "Spotify4Me", object: "volume\(sender.integerValue)")
        centerReceiver.postNotification(notify)
    }
    @IBAction func refreshButton(sender: AnyObject) {
        let notify = NSNotification(name: "Spotify4Me", object: "update")
        centerReceiver.postNotification(notify)
    }
    @IBAction func previousButton(sender: AnyObject) {
        let notify = NSNotification(name: "Spotify4Me", object: "back")
        centerReceiver.postNotification(notify)
    }
    @IBAction func nextButton(sender: AnyObject) {
        let notify = NSNotification(name: "Spotify4Me", object: "skip")
        centerReceiver.postNotification(notify)
    }
    @IBAction func playpauseButton(sender: AnyObject) {
        let notify = NSNotification(name: "Spotify4Me", object: "playpause")
        centerReceiver.postNotification(notify)
    }
    
    
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        if initialize {
            setReceiver()
        }
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        let notify = NSNotification(name: "Spotify4Me", object: "update")
        var app: [NSRunningApplication] = NSRunningApplication.runningApplicationsWithBundleIdentifier("com.spotify.client") as [NSRunningApplication]
        if app.isEmpty {
            spotifyStarted = false
            isHiddenBefore = true
            setHidden(true)
        }else{
            spotifyStarted = true
            centerReceiver.postNotification(notify)
        }
        completionHandler(.NewData)
    }

    func refreshView(){
        let state = information[smState] as String
        if state == "kPSS" {
            isHiddenBefore = true
            setHidden(true)
            return
        }
        if isHiddenBefore {
            isHiddenBefore = false
            setHidden(false)
        }
        
        titleOutput.stringValue = information[smTitle] as String
        albumOutput.stringValue = information[smAlbum] as String
        artistOutput.stringValue = information[smArtist] as String
        let vol: String = information[smVolume] as String
        volumeSlider.integerValue = vol.toInt()!
        let coverAsData = information[smCover] as NSData
        coverOutput.image = NSImage(data: coverAsData)
        if state == "kPSP" {
            playpauseButton.image = pauseImage
        }else if state == "kPSp" {
            playpauseButton.image = playImage
        }
    }
    
    func setHidden(state: Bool){
        titleOutput.hidden = state
        albumOutput.hidden = state
        artistOutput.hidden = state
        coverOutput.hidden = state
        volumeSlider.hidden = state
        previousButton.hidden = state
        nextButton.hidden = state
        playpauseButton.hidden = state
        
        if state == false {
            titleHeight.constant = textfieldrestore
            albumHeight.constant = textfieldrestore
            artistHeight.constant = textfieldrestore
            artist2refreshHeight.constant = artist2refreshrestore
            coverHeight.constant = coverrestore
            //view2refreshHeight.constant = viewHeightActive
        }else {
            titleHeight.constant = eliminateHeight
            albumHeight.constant = eliminateHeight
            artistHeight.constant = eliminateHeight
            artist2refreshHeight.constant = eliminateHeight
            coverHeight.constant = CGFloat(10)
            //view2refreshHeight.constant = viewHeightPassive
            
        }
    }
    
}
