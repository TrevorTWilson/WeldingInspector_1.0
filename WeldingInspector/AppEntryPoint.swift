//
//  RewriteVersion4App.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-03.
//

import SwiftUI


@main
struct AppEntryPoint: App {
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var multipeerManager = MultipeerConnectivityManager()

    var body: some Scene {
        WindowGroup {
            MainJobView()
                .environmentObject(mainViewModel)
                .environmentObject(multipeerManager)
                
        }
    }
}


