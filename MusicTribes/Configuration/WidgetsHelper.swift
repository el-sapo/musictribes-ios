//
//  WidgetsHelper.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 31/10/24.
//

import ActivityKit

// MARK: Live Avtivities
struct MusicActivityWidgetAttributes: ActivityAttributes {

    public struct ContentState: Codable, Hashable {
        var trackName: String
        var artistName: String
        var imageUrl: String?
    }
    var name: String
}

class WidgetsHelper {
    static let shared = WidgetsHelper()
    var activity: Activity<MusicActivityWidgetAttributes>? = nil

    func startMainActivity() {
        Task {
            let initialContentState = MusicActivityWidgetAttributes.ContentState(
                trackName: "elsapo.eth",
                artistName: "MusicTribes",
                imageUrl: nil
            )

            let activityAttributes = MusicActivityWidgetAttributes(name: "elsapo.eth")
            let activityContent = ActivityContent(state: initialContentState, staleDate: nil)

            do {
                activity = try Activity<MusicActivityWidgetAttributes>.request(
                    attributes: activityAttributes,
                    content: activityContent,
                    pushType: nil // We don't need push notifications in this case.
                )
                print("Started Music Activity")
            } catch {
                print("Error starting activity: \(error.localizedDescription)")
            }
        }
    }

    func stopActivities() {
        Task {
            for a in Activity<MusicActivityWidgetAttributes>.activities {
                await a.end(nil, dismissalPolicy: .immediate)
                print("Stopping activity!!")
            }
            await activity?.end(nil, dismissalPolicy: .immediate)
        }
    }
}
