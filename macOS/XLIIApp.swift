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
   
    
    var cameraView:some View{
        
        let c=CameraView()
            .toolbar {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(action: {
                        presentingCamera=false
                    }, label: {
                        Text("Dismiss")
                        
                    })
                })
            }
        #if os(macOS)
        return c
        #else
        return NavigationView(content: {
            c.navigationBarTitleDisplayMode(.inline)
        })
        #endif
    }
    

    

    var body: some Scene {
        WindowGroup{
            ContentView(holder: ConversionInputHolder())
                .toolbar(content: {
                    ToolbarItem(placement: .automatic, content: {
                        Button(action: {
                            presentingCamera=true
                        }, label: {
                            Image(systemName: "camera")
                        })
                    })
                })
                .sheet(isPresented: $presentingCamera, onDismiss: {
                    
                }, content: {
                    cameraView
                })
        }
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.titleBar)
        
        
        Settings {
            VStack{
                SettingsView()
            }.padding()
            
        }.windowToolbarStyle(.unified(showsTitle: true))
            .windowStyle(.titleBar)
        
        
    }
}
