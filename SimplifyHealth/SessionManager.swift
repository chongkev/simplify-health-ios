//
//  SessionManager.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import Combine

enum SessionState {
    case signedOut
    case signedIn(Session)
}

extension SessionState {
    var isSignedIn: Bool {
        switch self {
        case .signedIn: true
        case .signedOut: false
        }
    }
}

struct Session {
    let username: String
}

protocol SessionInfo {
    var sessionState: SessionState { get }
    var sessionStatePublisher: AnyPublisher<SessionState, Never> { get }
}

protocol SessionSignIn {
    func signIn(email: String, password: String) async throws
}

protocol SessionSignUp {
    func signUp(email: String, password: String) async throws
}

protocol SessionSignOut {
    func signOut()
}

// MARK: Dummy implementation

class DummySessionManager: SessionInfo, SessionSignIn, SessionSignUp, SessionSignOut {
    @Published private(set) var sessionState: SessionState = .signedOut
    var sessionStatePublisher: AnyPublisher<SessionState, Never> { $sessionState.eraseToAnyPublisher() }
    
    func signIn(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        self.sessionState = .signedIn(.init(username: email))
    }
    
    func signUp(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        self.sessionState = .signedIn(.init(username: email))
    }
    
    func signOut() {
        switch sessionState {
        case .signedIn: sessionState = .signedOut
        case .signedOut: assertionFailure(); break
        }
    }
}

extension Dummy {
    static var sessionInfo: SessionInfo { DummySessionManager() }
    static var sessionSignIn: SessionSignIn { DummySessionManager() }
    static var sessionSignUp: SessionSignUp { DummySessionManager() }
    static var sessionSignOut: SessionSignOut { DummySessionManager() }
}
