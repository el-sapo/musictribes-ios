//
//  MusicPlayerManager+Activities.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 31/10/24.
//

#if canImport(ActivityKit)

import ActivityKit

extension MusicPlayerManager {

    func startMusicActivity(track: String, artist: String, imageUrl: String?, playlist: String) {
        Task {
           // let localImageName = await activityImageLocation(urlString: imageUrl)
//#if os(iOS)
#if targetEnvironment(macCatalyst)

            let initialContentState = MusicActivityWidgetAttributes.ContentState(
                trackName: track,
                artistName: artist,
                imageUrl: imageUrl
            )

            let activityAttributes = MusicActivityWidgetAttributes(name: playlist)
            let activityContent = ActivityContent(state: initialContentState, staleDate: nil)

            do {
                WidgetsHelper.shared.activity = try Activity<MusicActivityWidgetAttributes>.request(
                    attributes: activityAttributes,
                    content: activityContent,
                    pushType: nil // We don't need push notifications in this case.
                )
                print("Started Music Activity")
            } catch {
                print("Error starting activity: \(error.localizedDescription)")
            }
        }
#endif

    }

    func updateMusicActivity(track: String, artist: String, imageUrl: String?) {
#if os(iOS)

        guard let activity = WidgetsHelper.shared.activity else { return }

        Task {
            //let localImageName = await activityImageLocation(urlString: imageUrl)
            let updateState = MusicActivityWidgetAttributes.ContentState(
                trackName: track,
                artistName: artist,
                imageUrl: imageUrl
            )
            await activity.update(using: updateState)
            //            for activity in Activity<MusicActivityWidgetAttributes>.activities {
            //              await activity.update(using: .init(trackName: track, artistName: artist, isPlaying: isPlaying))
            //          }
        }
#endif

    }

    func stopMusicActivity() {
#if os(iOS)

        guard let activity = WidgetsHelper.shared.activity else { return }
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            print("stopMusicActivity")

            //            for activity in Activity<MusicActivityWidgetAttributes>.activities {
            //               await activity.end(dismissalPolicy: .immediate)
            //          }
        }
#endif

    }

    func activityImageLocation(urlString: String?) async -> String? {
            guard let imageUrl = urlString, let localImageURL = await Utils.downloadAndCacheImage(from: imageUrl)  else {
                print("Invalid URL string.")
                return nil
            }
            return localImageURL
        }
}

#endif
