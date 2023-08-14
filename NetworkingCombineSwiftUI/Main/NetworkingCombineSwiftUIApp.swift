//
//  NetworkingCombineSwiftUIApp.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import SwiftUI

@main
struct NetworkingCombineSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "play.tv.fill")
                    }
                PodcastsView()
                    .tabItem {
                        Label("Podcasts", systemImage: "beats.headphones")
                    }
            }
        }
    }
}
