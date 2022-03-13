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
            ContentView()

        }
        .windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowStyle(.titleBar)
        .commands(content: {
            AppCommands()
//            ImportFromDevicesCommands()
        })
        .defaultAppStorage(.shared)
        
        
        Settings {
            VStack{
                SettingsView()
                    .defaultAppStorage(.shared)
            }.padding()
            
        }
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.titleBar)
        
        
    }
}
