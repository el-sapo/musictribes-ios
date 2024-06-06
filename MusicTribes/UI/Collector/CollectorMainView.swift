//
//  CollectorMainView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 17/5/24.
//

import SwiftUI

struct CollectorMainView: View {
    var body: some View {
        ZStack {
                Spacer(minLength: 40)
                CollectorGridView(
                    gridData: MockData.collectedArtists
                )
            VStack {
                CollectorTitleView(title: "elsapo.eth")
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 1, leading: 3, bottom: 0, trailing: 3))
    }
}

#Preview {
    CollectorMainView()
}


// this could be the title view
struct CollectorTitleView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
            Spacer()
        }
    }
}

