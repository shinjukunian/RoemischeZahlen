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
            NavigationView{
                ContentView()
                    
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("XLII"))
                    .fullScreenCover(isPresented: $presentingCamera, content: {
                        CameraView()
                    })
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction, content: {
                            CameraButton(showCamera: $presentingCamera)
                        })
                    })
                
                
            }.navigationViewStyle(.stack)
        }
    }
}
