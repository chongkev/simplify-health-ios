//
//  LaunchView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI
import Combine

struct LaunchView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.isSignedIn {
            MainView()
        } else {
            SignInView()
        }
    }
}

extension LaunchView {
    class ViewModel: ObservableObject {
        @Published fileprivate var isSignedIn: Bool = false
    }
}

#Preview {
    LaunchView(viewModel: .init())
}
