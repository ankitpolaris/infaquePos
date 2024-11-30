//
//  SplashScreenView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea(.all)
            VStack {
                Image("brandLogo")
                    .resizable()
                    .scaledToFit()
            }.padding(.all)
            
                
        }
    }
}

#Preview {
    SplashScreenView()
}
