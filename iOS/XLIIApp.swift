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
        
        return c
    }
    
    
    var body: some Scene {
        WindowGroup{
            NavigationView{
                ContentView(holder: ConversionInputHolder())
                    
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("XLII"))
                    .fullScreenCover(isPresented: $presentingCamera, content: {
                        cameraView
                    })
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction, content: {
                            Button(action: {
                                presentingCamera=true
                            }, label: {
                                Image(systemName: "camera")
                            })
                        })
                    })
                
                
            }.navigationViewStyle(.stack)
        }
    }
}
