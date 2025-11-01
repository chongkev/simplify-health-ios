//
//  SignInView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI
import Combine

struct SignInView: View {
    @EnvironmentObject private var appEnv: AppEnv
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: login) {
                Text("Sign In")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isSignInButtonDisabled)
            .opacity(isSignInButtonDisabled ? 0.55: 1)
            
            Spacer()
            
            Button("Don't have an account? Sign Up") {
                viewModel.isShowingSignUp.toggle()
            }
            .disabled(isSignUpButtonDisabled)
            .opacity(isSignUpButtonDisabled ? 0.55: 1)
        }
        .frame(maxWidth: horizontalSizeClass == .regular ? 540 : .infinity) // 540 is the default size for Sheet on iPads
        .padding(24)
        .sheet(isPresented: $viewModel.isShowingSignUp) {
            SignUpView(viewModel: .init(sessionSignUp: appEnv.dependencyProvider.provideSessionSignUp()))
        }
    }
    
    var isSignInButtonDisabled: Bool {
        viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.isSigningIn
    }
    var isSignUpButtonDisabled: Bool { viewModel.isSigningIn }
    
    private func login() {
        Task { @MainActor in
            viewModel.isSigningIn = true
            do {
                try await viewModel.signIn()
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
            viewModel.isSigningIn = false
        }
    }
}

extension SignInView {
    class ViewModel: ObservableObject {
        @Published fileprivate var email = ""
        @Published fileprivate var password = ""
        @Published fileprivate var errorMessage: String?
        @Published fileprivate var isSigningIn: Bool = false
        @Published fileprivate var isShowingSignUp = false
        private let sessionSignIn: SessionSignIn
        
        init(sessionSignIn: SessionSignIn) {
            self.sessionSignIn = sessionSignIn
        }
        
        fileprivate func signIn() async throws {
            try await sessionSignIn.signIn(email: email, password: password)
        }
    }
}

#Preview {
    SignInView(viewModel: .init(sessionSignIn: Dummy.sessionSignIn))
}
