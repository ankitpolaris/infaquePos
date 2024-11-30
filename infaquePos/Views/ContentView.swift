//
//  ContentView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // Retrieve login state
    
    
    var body: some View {
        
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5), value: 0)
            } else {
                
                if isLoggedIn {
                    NavigationView {
                        HomeTabBarUIView()
                    }
                    
                } else {
                    LoginOptionsUIView()
                }
            }
        }
        
        .onAppear() {
            DispatchQueue.main
                .asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.showSplash = false
                    }
                }
        }
        
    }
}

#Preview {
    ContentView()
}
