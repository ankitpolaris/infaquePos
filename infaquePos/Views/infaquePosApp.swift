//
//  infaquePosApp.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Restore sign-in failed: \(error.localizedDescription)")
            } else {
                print("Restore sign-in succeeded for user: \(user?.profile?.name ?? "Unknown")")
            }
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct infaquePosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
