//
//  MusicPlayerIntent.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 1/11/24.
//


import AppIntents

/*
struct SoundMakerIntent: AudioPlaybackIntent {
    typealias PerformResult = <#type#>
    
    typealias SummaryContent = <#type#>
    
    static var title: LocalizedStringResource
    

}

struct PlaybackIntent: AudioPlaybackIntent {
    static var title: LocalizedStringResource = "Audio Playback Control"

    // Define parameters, such as whether to play or pause
    @Parameter(title: "Playback Action")

/*    // Enum to specify actions
    enum PlaybackAction: String, AppEnum {
        static var typeDisplayRepresentation: TypeDisplayRepresentation
        
        static var caseDisplayRepresentations: [PlaybackIntent.PlaybackAction : DisplayRepresentation]
        
        case play, pause, skip
    }*/

    // Define how to handle the action when invoked
    func perform() async throws -> some IntentResult {
        switch action {
        case .play:
            // Trigger play logic in the app
            MusicPlayerManager.shared.play()
        case .pause:
            // Trigger pause logic in the app
            MusicPlayerManager.shared.pause()
        case .skip:
            // Trigger skip logic in the app
            MusicPlayerManager.shared.next()
        }

        return .result()
    }
}
 */
