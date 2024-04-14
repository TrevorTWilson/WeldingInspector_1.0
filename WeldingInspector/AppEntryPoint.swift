//
//  RewriteVersion4App.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-03.
//

import SwiftUI


@main
struct AppEntryPoint: App {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            let weldingInspectorName = mainViewModel.weldingInspector.name // Extract the name here

            MainJobView()
                .environmentObject(mainViewModel)
                .environmentObject(MultipeerConnectivityManager(userName: weldingInspectorName))
        }
    }
}



