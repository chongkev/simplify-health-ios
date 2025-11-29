//
//  SessionManager.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import Combine
import FirebaseAuth

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

protocol SessionPasswordReset {
    func resetPassword(email: String) async throws
}

protocol SessionSignOut {
    func signOut() throws
}

final class SessionManagerDefault: SessionInfo, SessionSignIn, SessionSignUp, SessionSignOut, SessionPasswordReset {
    private let auth: Auth
    @Published private(set) var sessionState: SessionState = .signedOut
    var sessionStatePublisher: AnyPublisher<SessionState, Never> { $sessionState.eraseToAnyPublisher() }

    init(auth: Auth) {
        self.auth = auth
        sessionState = auth.currentUser.map { .signedIn(.init(username: $0.email ?? $0.uid)) } ?? .signedOut
    }
    
    func signIn(email: String, password: String) async throws {
        switch sessionState {
        case .signedIn:
            assertionFailure()
            return
        case .signedOut:
            let result = try await auth.signIn(withEmail: email, password: password)
            sessionState = .signedIn(.init(username: result.user.email ?? result.user.uid))
        }
    }
    
    func signUp(email: String, password: String) async throws {
        switch sessionState {
        case .signedIn:
            assertionFailure()
            return
        case .signedOut:
            let result = try await auth.createUser(withEmail: email, password: password)
            sessionState = .signedIn(.init(username: result.user.email ?? result.user.uid))
        }
    }
    
    func signOut() throws {
        switch sessionState {
        case .signedIn:
            try auth.signOut()
            sessionState = .signedOut
        case .signedOut:
            assertionFailure()
            return
        }
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
}

// MARK: Dummy implementation

final class DummySessionManager: SessionInfo, SessionSignIn, SessionSignUp, SessionSignOut, SessionPasswordReset {
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
    
    func signOut() throws {
        switch sessionState {
        case .signedIn: sessionState = .signedOut
        case .signedOut: assertionFailure(); break
        }
    }
    
    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
