//
//  MusicTribesSApp.swift
//  MusicTribesS
//
//  Created by Federico Lagarmilla on 16/6/24.
//

import SwiftUI
import MediaPlayer

@main
struct MusicTribesSApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .edgesIgnoringSafeArea(.all)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        // Save data or perform cleanup when app enters the background
                    } else if newPhase == .inactive {
                        // Handle when app becomes inactive
                    } else if newPhase == .active {
                        // Handle when app becomes active again
                    }
                }
                .onAppear {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true )
                    } catch {
                        print(error)
                    }
                    MusicPlayerManager.shared.setupRemoteCommandCenter()
                }
        }
    }
}
/*
struct MusicTribesWidgetBundle: WidgetBundle {
    var body: some Widget {
        MusicActivityWidget()
    }
}
*/
