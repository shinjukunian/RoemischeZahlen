//
//  XLIIApp.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI

@main
struct XLIIApp: App {
    
    @State private var presentingCamera = false

    var body: some Scene {
        WindowGroup{
            ContentView()
                .toolbar(content: {
                    ToolbarItem(placement: .automatic, content: {
                        CameraButton(showCamera: $presentingCamera)
                    })
                })
                .sheet(isPresented: $presentingCamera, onDismiss: {
                    
                }, content: {
                    CameraView()
                })
        }
        .windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowStyle(.titleBar)
        .commands(content: {
            FeedbackButton()
        })
        
        
        
        Settings {
            VStack{
                SettingsView()
            }.padding()
            
        }.windowToolbarStyle(.unified(showsTitle: true))
            .windowStyle(.titleBar)
        
        
    }
}
