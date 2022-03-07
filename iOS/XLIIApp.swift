//
//  XLIIApp.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI

@main
struct XLIIApp: App {
    
    init(){
        UserDefaults.shared.registerDefaults()
    }
    
    var body: some Scene {
        WindowGroup{
            NavigationView{
                ContentView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("XLII"))
                
            }
            .navigationViewStyle(.stack)
            .defaultAppStorage(.shared)
        }
    }
}
