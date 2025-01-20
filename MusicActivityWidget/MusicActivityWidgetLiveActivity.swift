//
//  MusicActivityWidgetLiveActivity.swift
//  MusicActivityWidget
//
//  Created by Federico Lagarmilla on 31/10/24.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct MusicActivityView: View {
    let context: ActivityViewContext<MusicActivityWidgetAttributes>

    var body: some View {
        HStack(alignment: .center) {
            if let imageUrl = context.state.imageUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url),
                let uiImage = UIImage(data: imageData) {
//            if let imageUrl = context.state.imageUrl, let uiImage = UIImage(contentsOfFile: imageUrl) {
                Image(uiImage: uiImage)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50.0, height: 50.0)
                    .padding(5.0)
            } else {
                Image("icon-mt")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("LiveFontColor"))
                    .padding(5.0)
            }
            VStack {
                    VStack(alignment: .leading) {
                        Text(context.state.trackName)
                            .font(.headline)
                            .foregroundStyle(Color("LiveFontColor"))
                        Text(context.state.artistName)
                            .font(.caption)
                            .foregroundStyle(Color("LiveFontColor"))
                    }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 40.0)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.black) // Background color for the rounded rectangle
                .opacity(0.8)
        )
    }

    func musicImage() -> String? {
        return nil
    }
}

struct MusicActivityWidgetLiveActivity: Widget {
    let kind: String = "MusicActivity_Widget" 

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicActivityWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            MusicActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image("icon-mt")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("LiveFontColor"))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("elsapo.eth")
                        .font(.caption)
                        .foregroundStyle(Color("LiveFontColor"))}
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.trackName)
                        .font(.headline)
                        .foregroundStyle(Color("LiveFontColor"))
                }
            } compactLeading: {
                Text("elsapo.eth")
                    .foregroundStyle(Color("LiveFontColor"))
            } compactTrailing: {
                Image("icon-mt")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("LiveFontColor"))
            } minimal: {
                Image("icon-mt")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("LiveFontColor"))
            }
        }
    }
}

extension MusicActivityWidgetAttributes {
    fileprivate static var preview: MusicActivityWidgetAttributes {
        MusicActivityWidgetAttributes(name: "MT")
    }
}

extension MusicActivityWidgetAttributes.ContentState {
    fileprivate static var play: MusicActivityWidgetAttributes.ContentState {
        MusicActivityWidgetAttributes.ContentState(trackName: "track 1", artistName: "Sound of fractures", imageUrl: nil)
    }

    fileprivate static var next: MusicActivityWidgetAttributes.ContentState {
        MusicActivityWidgetAttributes.ContentState(trackName: "next track", artistName: "TK", imageUrl: nil)
     }
    }

#Preview("Notification", as: .content, using: MusicActivityWidgetAttributes.preview) {
   MusicActivityWidgetLiveActivity()
} contentStates: {
    MusicActivityWidgetAttributes.ContentState.play
    MusicActivityWidgetAttributes.ContentState.next
}
