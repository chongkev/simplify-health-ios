//
//  SignUpView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//


import SwiftUI
import Combine

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(10)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: { viewModel.showAlert = true; viewModel.isSigningUp = true }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isSignUpButtonDisabled)
                .opacity(isSignUpButtonDisabled ? 0.55: 1)
                
                Spacer()
            }
            .padding(24)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.disabled(viewModel.isSigningUp)
            )
            .alert(
                "Please confirm",
                isPresented: $viewModel.showAlert,
                presenting: viewModel.email
            ) { email in
                Button("Confirm") {
                    signUp()
                }
                Button(role: .cancel) {
                    viewModel.isSigningUp = false
                } label: {
                    Text("Cancel")
                }
            } message: { email in
                Text("You are about to create an account for \(email)")
            }
        }
    }
    
    var isSignUpButtonDisabled: Bool {
        !viewModel.email.trimmed.isValidEmail || viewModel.password.isEmpty || viewModel.isSigningUp
    }
    
    private func signUp() {
        Task { @MainActor in
            if await viewModel.signUp() {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension SignUpView {
    class ViewModel: ObservableObject {
        @Published fileprivate var email = ""
        @Published fileprivate var password = ""
        @Published fileprivate var errorMessage: String?
        @Published fileprivate var isSigningUp = false
        @Published fileprivate var showAlert = false
        private let sessionSignUp: SessionSignUp
        
        init(sessionSignUp: SessionSignUp) {
            self.sessionSignUp = sessionSignUp
        }

        fileprivate func signUp() async -> Bool {
            isSigningUp = true
            do {
                try await sessionSignUp.signUp(email: email, password: password)
                isSigningUp = false
                return true
            } catch {
                isSigningUp = false
                errorMessage = error.localizedDescription
                return false
            }
        }
    }
}


extension StringProtocol {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var isBlank: Bool { trimmed.isEmpty }
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
            return !regex.matches(in: String(self), range: NSRange(location: 0, length: count)).isEmpty
        } catch {
            return false
        }
    }
}

#Preview {
    SignUpView(viewModel: .init(sessionSignUp: Dummy.sessionSignUp))
}
