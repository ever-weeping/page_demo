//
//  ContentView.swift
//  sohi
//

import SwiftUI
import demoResource

struct ContentView: View {
    var body: some View {
//        TabView{
//            SearchView()
//                .tabItem {
//                    Label("搜索", systemImage: "magnifyingglass")
//                }
//            RootTabBarView()
//                .tabItem {
//                    Label("test",systemImage: "house")
//                }
//        }
        RootTabBarRepresentable()
            .ignoresSafeArea()
            .demoToast()
            .demoAlert()
    }
}

struct RootTabBarRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RootTabBarController {
        RootTabBarController()
    }

    func updateUIViewController(_ uiViewController: RootTabBarController, context: Context) {}
}

#Preview {
    ContentView()
}
