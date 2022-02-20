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
    @State private var presentSettings = false
    
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
    
    var textInputView:some View{
        let holder=ConversionInputHolder()
        return ContentView(holder: holder)
            
            .toolbar(content: {
                ToolbarItem(placement: .automatic, content: {
                    Button(action: {
                        presentingCamera=true
                    }, label: {
                        Image(systemName: "camera")
                    })
                })
                
            })
    }
    
    @ViewBuilder func makeTextInputView()-> some View{
        
        let t=textInputView
        
#if os(macOS)
        t//.frame(maxWidth: 400, maxHeight: .infinity)
        .sheet(isPresented: $presentingCamera, onDismiss: {
            
        }, content: {
            cameraView
        })
        
#else
        NavigationView(content: {
            t.fullScreenCover(isPresented: $presentingCamera, onDismiss: {
                
            }, content: {
                cameraView
            })
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("XLII"))
                
        }).navigationViewStyle(.stack)
#endif
    }
    
    var windowScene:some Scene{
        let w=WindowGroup{
            makeTextInputView()
        }
        #if os(macOS)
        return w
            .windowToolbarStyle(UnifiedWindowToolbarStyle())
            .windowStyle(HiddenTitleBarWindowStyle())
        #else
        return w
        #endif
    }
        
    
    var body: some Scene {
        windowScene
        
//        #if os(macOS)
//        Settings {
//            SettingsView()
//        }
//        #endif
        
    }
}
