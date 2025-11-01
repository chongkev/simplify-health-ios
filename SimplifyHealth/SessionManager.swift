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

// MARK: Dummy implementation

class DummySessionManager: SessionInfo, SessionSignIn {
    @Published private(set) var sessionState: SessionState = .signedOut
    var sessionStatePublisher: AnyPublisher<SessionState, Never> { $sessionState.eraseToAnyPublisher() }
    func signIn(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        self.sessionState = .signedIn(.init(username: email))
    }
}

extension Dummy {
    static var sessionInfo: SessionInfo { DummySessionManager() }
    static var sessionSignIn: SessionSignIn { DummySessionManager() }
}
