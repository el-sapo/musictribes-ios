//
//  MTLiveActivities.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 30/10/24.
//

#if canImport(ActivityKit)

import ActivityKit
import SwiftUI
import WidgetKit

struct MusicActivityView: View {
    let contentState: MusicActivityWidgetAttributes.ContentState

    var body: some View {
        VStack {
            HStack {
                Text("elsapo.eth")
                    .font(.headline)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(contentState.trackName)
//                        .myFont(style: .bold, size: 16.0)
                    Text(contentState.artistName)
//                        .myFont(style: .regular, size: 16.0)
                }
                Spacer()
                if contentState.isPlaying {
                    Image(systemName: "pause.fill")
                } else {
                    Image(systemName: "play.fill")
                }
            }
        }
        .background(Color.customGreen)
        .padding()
    }
}


struct MusicActivityWidget_Old: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicActivityWidgetAttributes.self) { context in
            // Create the presentation that appears on the Lock Screen and as a
            // banner on the Home Screen of devices that don't support the
            // Dynamic Island.
            MusicActivityView(
                contentState: context.state
            )
            .activityBackgroundTint(Color.customGreen.opacity(0.25))
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                expandedContent(
                    contentState: context.state
                )
            } compactLeading: {
                Image("AppIcon")
            } compactTrailing: {
                // Create the compact trailing presentation.
                Text(context.state.trackName)
            } minimal: {
                // Create the minimal presentation.
                Image("AppIcon")
            }

        }
    }

    @DynamicIslandExpandedContentBuilder
    private func expandedContent(contentState: MusicActivityWidgetAttributes.ContentState) -> DynamicIslandExpandedContent<some View> {

        DynamicIslandExpandedRegion(.leading) {
            Text(contentState.trackName)
                .font(.title2)
        }
        DynamicIslandExpandedRegion(.trailing) {
            if contentState.isPlaying {
                Image(systemName: "pause.fill")
            } else {
                Image(systemName: "play.fill")
            }
        }
        DynamicIslandExpandedRegion(.center) {
            Text(contentState.artistName)
                .font(.subheadline)
        }
        DynamicIslandExpandedRegion(.bottom) {
            Text("elsapo.eth")
                .font(.caption)
        }
    }
}
#endif
