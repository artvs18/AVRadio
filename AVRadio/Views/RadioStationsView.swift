//
//  RadioStationsView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import SwiftUI
import Combine

struct RadioStationsView: View {
    @AppStorage("keyColor") var keyColor = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    @ObservedObject private var viewModel = RadioStationsViewModel()
    @State private var countryCode: String = "RU"
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.radioStations, id: \.id) { station in
                    NavigationLink {
                        PlayerView(radioStation: station)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: station.favicon), transaction: Transaction(animation: .default)) {
                                switch $0 {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                case .failure:
                                    Image(systemName: "radio")
                                        .resizable()
                                        .padding(10)
                                        .background(Color.accentColor)
                                @unknown default:
                                    fatalError()
                                }
                            }
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                            .cornerRadius(12)
                            
                            Text(station.name)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchRadioStations(countryCode: countryCode)
                }
                .refreshable {
                    viewModel.fetchRadioStations(countryCode: countryCode)
                }
                .navigationBarTitle("AVRadio")
            }
        }
        .tint(keyColor)
    }
}

struct RadioStations_Previews: PreviewProvider {
    static var previews: some View {
        RadioStationsView()
    }
}
