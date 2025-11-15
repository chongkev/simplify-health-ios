//
//  LaunchView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI
import Combine

struct LaunchView: View {
    @EnvironmentObject private var appEnv: AppEnv
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isSignedIn {
                MainView(viewModel: mainViewViewModel)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                SignInView(viewModel: .init(sessionSignIn: appEnv.dependencyProvider.provideSessionSignIn()))
//                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isSignedIn)
    }
    
    var mainViewViewModel: MainView.ViewModel {
        .init(
            sessionInfo: appEnv.dependencyProvider.provideSessionInfo(),
            sessionSignOut: appEnv.dependencyProvider.provideSessionSignOut()
        )
    }
}

extension LaunchView {
    class ViewModel: ObservableObject {
        @Published fileprivate var isSignedIn: Bool = false
        init(sessionInfo: SessionInfo) {
            sessionInfo.sessionStatePublisher.map(\.isSignedIn).assign(to: &$isSignedIn)
        }
    }
}

#Preview {
    LaunchView(viewModel: .init(sessionInfo: Dummy.sessionInfo))
}
