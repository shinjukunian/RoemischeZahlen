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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbar(content: {
                    ToolbarItem(placement: .automatic, content: {
                        Button(action: {
                            presentingCamera=true
                        }, label: {
                            Image(systemName: "camera")
                        })
                    })
                    
                }).sheet(isPresented: $presentingCamera, onDismiss: {
                    
                }, content: {
                    CameraView()
                        .toolbar {
                            ToolbarItem(placement: .automatic, content: {
                                Button(action: {
                                    presentingCamera=false
                                }, label: {
                                    Text("Dismiss")
                                    
                                })
                            })
                        }
                    
                })
        }
    }
}
