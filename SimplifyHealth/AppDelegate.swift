//
//  AppDelegate.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import UIKit
import Combine
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    lazy var appEnv: AppEnv = {
        AppEnv(dependencyProvider: DependencyProviderDefault())
    }()
}

final class AppEnv: ObservableObject {
    let dependencyProvider: DependencyProvider
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
}

protocol DependencyProvider {
    func provideSessionInfo() -> SessionInfo
    func provideSessionSignIn() -> SessionSignIn
    func provideSessionSignUp() -> SessionSignUp
    func provideSessionSignOut() -> SessionSignOut
}

final class DependencyProviderDefault {
    private lazy var sessionManager = { DummySessionManager() }()
}

extension DependencyProviderDefault: DependencyProvider {
    func provideSessionInfo() -> SessionInfo { sessionManager }
    func provideSessionSignIn() -> SessionSignIn { sessionManager }
    func provideSessionSignUp() -> SessionSignUp { sessionManager }
    func provideSessionSignOut() -> SessionSignOut { sessionManager }
}

enum Dummy {} /// Providing a namespace for dummy conformances to protocols etc
