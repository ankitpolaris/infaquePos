//
//  HomeTabBarUIView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 28/11/24.
//

import SwiftUI


struct HomeTabBarUIView: View {
    @State private var isMenuOpen = false
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // Retrieve login state
    @State private var isChangePasswordPresented = false // Track the state to present ChangePasswordView

    
    var body: some View {
        
        ZStack {
            TabBarView()
            
            
            
            // Overlay for sliding menu
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
            }
            
            // Sliding menu
            HStack {
                Spacer()
                if isMenuOpen {
                    RightPanelView(isMenuOpen: $isMenuOpen, isChangePasswordPresented: $isChangePasswordPresented)
                        .frame(width: 350)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                        .edgesIgnoringSafeArea(.all)

                }
            }
        }
        
        .navigationTitle(isMenuOpen ? "" : "Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $isChangePasswordPresented) {
                    ChangePasswordView(isPresented: $isChangePasswordPresented) // Correctly passing the binding
                }
    }
}

struct TabBarView: View {
    var body: some View {
        TabView {
            Text("Home Page")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Text("Collect Payment")
                .tabItem {
                    Label("Collect Payment", systemImage: "banknote")
                }
            
            Text("Profile Page")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct RightPanelView: View {
    @Binding var isMenuOpen: Bool
    @Binding var isChangePasswordPresented: Bool // Binding to control the sheet
    @State private var showAlert = false

    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
                List {
                    // Menu Item 1
                    HStack {
                        Button(action: {
                            print("Right Menu 1 tapped")
                            isMenuOpen = false
                        }) {
                            Text("Home")
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .padding(.top, 10)
                                .cornerRadius(8)
                        }
                    }
                    .listRowSeparator(.hidden)
                    Divider() // Full-width divider
                    
                    // Menu Item 2
                    HStack {

                        Button(action: {
                            print("Right Menu 2 tapped")
                            isChangePasswordPresented.toggle()
                            isMenuOpen = false
                        }) {
                            Text("Change Password")
                                .font(.title3)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                            //                            .padding()
                                .cornerRadius(8)
                        }
                    }
                    .listRowSeparator(.hidden)
                    Divider() // Full-width divider
                    
                    // Menu Item 3
                    HStack {
                        Button(action: {
                            print("Logout Button tapped")
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            showAlert = true
                            
                        }) {
                            Text("Logout")
                                .font(.title3)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 10)
                                .cornerRadius(8)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
                ZStack {
                    Image("brandLogo")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70.0)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                    Spacer()
                }
                .frame(height: 100)
                .background(Color.black)
                
            }
            .background(Color("InfaqueColors"))
            .shadow(radius: 10)
        }
        .background(Color("InfaqueColors"))
        .shadow(radius: 10)
        .background(
            AlertControllerView(
                isPresented: $showAlert,
                title: "Confirmation",
                message: "Are you sure you want to Logout?",
                confirmButtonTitle: "Confirm",
                onConfirm: {
                    signOut()
                }
            )
        )
    }
    
    func signOut() {
        isMenuOpen = false
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: LoginOptionsUIView())
            window.makeKeyAndVisible()
        }
    }
    
}


struct AlertControllerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmButtonTitle: String
    let onConfirm: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // A simple placeholder view controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Add Confirm Button
            alert.addAction(UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
                onConfirm()
                isPresented = false
            })
            
            // Add Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                isPresented = false
            })
            
            // Present the Alert
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

#Preview {
    HomeTabBarUIView()
}
