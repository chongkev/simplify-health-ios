//
//  SimplifyHealthApp.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI

@main
struct SimplifyHealthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView(viewModel: .init(sessionInfo: appDelegate.appEnv.dependencyProvider.provideSessionInfo()))
                .environmentObject(appDelegate.appEnv)
        }
    }
}
