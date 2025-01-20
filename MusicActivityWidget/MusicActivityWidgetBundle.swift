//
//  MusicActivityWidgetBundle.swift
//  MusicActivityWidget
//
//  Created by Federico Lagarmilla on 31/10/24.
//

import WidgetKit
import SwiftUI

@main
struct MusicActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        MusicActivityWidget()
        MusicActivityWidgetControl()
        MusicActivityWidgetLiveActivity()
    }
}
