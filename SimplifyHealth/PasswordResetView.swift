//
//  PasswordResetView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 22/11/2025.
//

import SwiftUI
import Combine

struct PasswordResetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if viewModel.showFurtherInstructions {
                    furtherInstructions
                } else {
                    passwordResetForm
                }
                
                Spacer()
            }
            .animation(.easeInOut(duration: 0.5), value: viewModel.showFurtherInstructions)
            .padding(24)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.disabled(viewModel.isResettingPassword || viewModel.showFurtherInstructions)
            )
        }
    }
    
    var passwordResetForm: some View {
        Group {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: { Task { @MainActor in await viewModel.resetPassword() } }) {
                Text("Reset Password")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isResetPasswordButtonDisabled)
            .opacity(isResetPasswordButtonDisabled ? 0.55: 1)
        }
    }
    
    var furtherInstructions: some View {
        Group {
            Text("Further instructions to reset your password have been sent to \(viewModel.email).")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Dismiss")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .opacity(isResetPasswordButtonDisabled ? 0.55: 1)
        }
    }
    
    var isResetPasswordButtonDisabled: Bool {
        !viewModel.email.trimmed.isValidEmail || viewModel.isResettingPassword
    }
}

extension PasswordResetView {
    class ViewModel: ObservableObject {
        @Published fileprivate var email = ""
        @Published fileprivate var errorMessage: String?
        @Published fileprivate var isResettingPassword: Bool = false
        @Published fileprivate var showFurtherInstructions: Bool = false
        private let sessionPasswordReset: SessionPasswordReset
        
        init(email: String, sessionPasswordReset: SessionPasswordReset) {
            self.email = email
            self.sessionPasswordReset = sessionPasswordReset
        }

        fileprivate func resetPassword() async {
            isResettingPassword = true
            do {
                try await sessionPasswordReset.resetPassword(email: email)
                showFurtherInstructions = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isResettingPassword = false
        }
    }
}

#Preview {
    PasswordResetView(viewModel: .init(email: "test@example.com", sessionPasswordReset: DummySessionManager()))
}
