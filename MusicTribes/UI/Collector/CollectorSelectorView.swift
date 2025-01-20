//
//  CollectorSelectorView.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 4/12/24.
//

import SwiftUI
import Combine

private struct Constants {
    static let buttonSize = 25.0
}

struct CollectorSelectorView: View {
    @ObservedObject var viewModel = CollectorSelectorViewModel()
    @EnvironmentObject var vmCollector: CollectorGridViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text("Curators")
                    .myFont(style: .bold, size: 18.0)
                    .foregroundColor(Color.customGreen)
                Spacer()
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "multiply.square")
                        .resizable()
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                        .foregroundColor(Color.customGreen)
                        .ifiOS18OrLater { view in
                            view.symbolEffect(.breathe.plain.byLayer)
                        }
                }
            }
            .padding(.bottom, 20.0)
            .padding()
            List(viewModel.collectorList) { collector in
                CollectorRowView(collectorName: collector.name)
                    .frame(height: 50.0)
                    .background(Color.clear) // Ensures transparent row
                    .listRowInsets(EdgeInsets()) // Removes padding from the row
                    .onTapGesture {
                        vmCollector.myCollectionData(collector.name)
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
/*                HStack {
                    Text(collector.name)
                        .myFont(style: .regular, size: 18.0)
                        .frame(height: 40.0)
                        .foregroundColor(Color.customGreen)
                        .listRowInsets(EdgeInsets()) // Removes padding from the row
                        .onTapGesture {
                            viewModel.selectCollector(collector.name)
                        }
                    Spacer()
                }
                .listRowInsets(EdgeInsets())
                .padding(.zero)
                .background(Color.customCream)
 */
            }
            .listStyle(PlainListStyle())
            .listRowSeparatorTint(.customGreen)
            .background(Color.customCream)
            .padding(.zero)
        }
        .background(Color.customCream.edgesIgnoringSafeArea(.all))
    }
}

struct CollectorRowView: View {
    var collectorName: String

    var body: some View {
        HStack {
            Text(collectorName)
                .myFont(style: .regular, size: 18.0)
                .foregroundColor(Color.customGreen)
            Spacer()
        }
        .frame(height: 50.0)
        .padding(.all, 16)
        .background(Color.customCream)
    }
}

#Preview {
    CollectorSelectorView()
}

struct Collector: Identifiable {
    var id = UUID()
    var name : String
}

class CollectorSelectorViewModel: ObservableObject {
    @Published var collectorList: [Collector] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadCollectors()
    }

    private func loadCollectors() {
        collectorList = [
            Collector(name: "elsapo.eth"),
            Collector(name: "cxy.eth"),
            Collector(name: "musicben.eth")
        ]
    }

    func selectCollector(_ collector: String) {

    }
}
