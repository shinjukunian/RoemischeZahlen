//
//  RoemischeZahlApp.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI

@main
struct RoemischeZahlApp: App {
    
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
        ContentView(holder: NumeralConversionHolder())
            .toolbar(content: {
                ToolbarItem(placement: .automatic, content: {
                    Button(action: {
                        presentingCamera=true
                    }, label: {
                        Image(systemName: "camera")
                    })
                })
                #if !os(macOS)
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        presentSettings=true
                    }, label: {
                        Image(systemName: "gearshape.2")
                    })
                })
                #endif
            })
    }
    
    @ViewBuilder func makeTextInputView()-> some View{
        let t=textInputView
        #if os(macOS)
        t.sheet(isPresented: $presentingCamera, onDismiss: {
            
        }, content: {
            cameraView
        })
        
        #else
        NavigationView(content: {
            t.fullScreenCover(isPresented: $presentingCamera, onDismiss: {
                
            }, content: {
                cameraView
            })
            .sheet(isPresented: $presentSettings, content: {
                NavigationView{
                    SettingsView().toolbar(content: {
                        ToolbarItem(placement: .confirmationAction, content: {
                            Button(action: {
                                presentSettings.toggle()
                            }, label: {
                                Text("Done")
                            })
                        })
                    })
                    .navigationBarTitle(Text("Settings"), displayMode: .inline)
                }
                
            })
            .navigationBarTitleDisplayMode(.inline).navigationTitle(Text("Numerals"))
        })
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
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
        
    }
}
