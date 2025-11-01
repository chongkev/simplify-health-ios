//
//  AppDelegate.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import UIKit
import Combine

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        return true
    }
    
    lazy var appEnv: AppEnv = {
        AppEnv(dependencyProvider: DependencyProviderDefault())
    }()
}

@MainActor
final class AppEnv: ObservableObject {
    let dependencyProvider: DependencyProvider
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
}

protocol DependencyProvider {
}

@MainActor
final class DependencyProviderDefault: DependencyProvider {
}
