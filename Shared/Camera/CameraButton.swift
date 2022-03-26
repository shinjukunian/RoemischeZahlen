//
//  CameraButton.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/05.
//

import SwiftUI

struct CameraShutterButton: View {
    
    let action:()->Void
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            ZStack{
                Circle().fill(.white).padding(12)
                Circle().stroke(.white, lineWidth: 5).padding(5)
            }
            .frame(width:80,height: 80)
            .opacity(0.75)
        })
        .buttonStyle(.plain)
        .keyboardShortcut(.space, modifiers: [])
        

            
            
       
    }
}

struct CameraShutterButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraShutterButton(action: {}).background(.black)
    }
}
