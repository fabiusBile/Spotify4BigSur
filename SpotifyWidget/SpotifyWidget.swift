//
//  SpotifyWidget.swift
//  SpotifyWidget
//
//  Created by Fabius Bile on 27.11.2020.
//  Copyright © 2020 Lucas Backert. All rights reserved.
//
	
import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    let defaults = UserDefaults(suiteName: "backert.apps")!
    
    func placeholder(in context: Context) -> SpotifyEntry {
        SpotifyEntry(date: Date(), title: "test")
    }
    
    fileprivate func getEntry() -> SpotifyEntry {
        let spotifyData = defaults.persistentDomain(forName: "backert.apps")!
        let coverAsData = spotifyData["smCover"] as! NSData?

        return SpotifyEntry(date: Date(),
            title:  (spotifyData["smTitle"] as! String),
            artistName: (spotifyData["smArtist"] as! String),
            albumName: (spotifyData["smAlbum"] as! String),
            isPlaying: (spotifyData["smState"] as! String) == "kPSP",
            image: coverAsData != nil ? NSImage(data: coverAsData! as Data) : nil
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpotifyEntry) -> ()) {
        let entry = getEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()){
        let entries: [SpotifyEntry] = [getEntry()]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SpotifyEntry: TimelineEntry {
    let date: Date
    var title: String = "title"
    var artistName: String = "artist"
    var albumName: String = "album"
    var isPlaying : Bool = false;
    var image: NSImage?
}

struct SpotifyWidgetEntryView : View {
    var entry: Provider.Entry
    
    static let widgetBackground: some View = ContainerRelativeShape().fill(Color.init(.sRGB, red: 0.89, green: 0.89, blue: 0.89, opacity: 0.75))
    
    func getCommandUrl(_ command : String) -> URL{
        return URL(string: "https://spotifyWidget:///\(command)")!
    }
    
    var body: some View {
        VStack{
            Link(destination: getCommandUrl(SpotifyCommands.open), label: {
                VStack(alignment: HorizontalAlignment.leading){
                    HStack{
                        if (entry.image != nil){
                            Image(nsImage: entry.image!)
                                .resizable()
                                .frame(width: 70.0, height: 70.0)
                                
                        }
                        VStack(alignment: HorizontalAlignment.leading){
                            Text(entry.title)
                                .font(.system(size: 18))
                                .foregroundColor(Color.init("AccentColor"))
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("\(entry.artistName) - \(entry.albumName)")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.init("AccentColor"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    HStack{
                        Spacer()
                        Link(destination: getCommandUrl(SpotifyCommands.prev)){
                            Image("prev")
                                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .leading)
                                .foregroundColor(Color.init("AccentColor"))
                        }
                        Spacer()
                        Link(destination: getCommandUrl(SpotifyCommands.play)){
                            Image(entry.isPlaying ? "pause" : "play")
                                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                                .resizable()
                                .frame(width: 32, height: 32, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.init("AccentColor"))
                        }
                        Spacer()
                        Link(destination: getCommandUrl(SpotifyCommands.next)){
                            Image("next")
                                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .trailing)
                                .foregroundColor(Color.init("AccentColor"))
                        }
                        Spacer()
                    }
                }
            })
        }.padding(15)
        
    }
}

@main
struct SpotifyWidget: Widget {
    let kind: String = "SpotifyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SpotifyWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(SpotifyWidgetEntryView.widgetBackground)
        }
        .configurationDisplayName("Spotify Widget")
        .description("Widget for Spotify.")
        .supportedFamilies([.systemLarge,.systemMedium])
    }
}

struct SpotifyWidget_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyWidgetEntryView(entry:
            SpotifyEntry(
                date: Date(),
                title: "some long title",
                artistName: "some artist name",
                albumName: "some album name",
                isPlaying: false,
                image: NSImage(named: "StubImage")
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpotifyWidgetEntryView.widgetBackground)
    }
}
