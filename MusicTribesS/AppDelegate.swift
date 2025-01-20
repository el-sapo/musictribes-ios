//
//  AppDelegate.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 25/10/24.
//

import SwiftUI
import MediaPlayer

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        setupRemoteTransportControls()
        setupBackgroundMusicPlayback()

        WidgetsHelper.shared.startMainActivity()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save any unsaved data or perform final cleanup here
        WidgetsHelper.shared.stopActivities()
        print("applicationWillTerminate MusicPlayerManager.shared.stopMusicActivity()")
    }
}

func setupBackgroundMusicPlayback() {
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
        print("AVAudioSession Playback OK")
        try AVAudioSession.sharedInstance().setActive(true)
        print("Session is Active")
    } catch let error {
        print("AVAudioSession Playback failed with error \(error)")
    }
}

func setupRemoteTransportControls() {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.addTarget { event in
        print("MPRemoteCommandCenter \(event)")
        MusicPlayerManager.shared.resume()
        return .success
    }

    commandCenter.pauseCommand.addTarget { event in
        print("MPRemoteCommandCenter \(event)")
        MusicPlayerManager.shared.pause()
        return .success
    }

    commandCenter.nextTrackCommand.addTarget { event in
        print("MPRemoteCommandCenter \(event)")
        MusicPlayerManager.shared.next()
        return .success
    }

    commandCenter.previousTrackCommand.addTarget { event in
        print("MPRemoteCommandCenter \(event)")
        MusicPlayerManager.shared.previous()
        return .success
    }
}
