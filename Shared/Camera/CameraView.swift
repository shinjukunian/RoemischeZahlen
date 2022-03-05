//
//  CameraView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import SwiftUI
import Combine
import XLIICore

struct CameraView: View {
    
    @StateObject var recognizer=Recognizer()
    
    @State var outputType:Output = .japanisch
    
    @State var convert:Bool = true
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var zoomScale: CGFloat = 4.0
    
    @State var selectedTextElement:Recognizer.TextElement?
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var holder:ConversionInputHolder
    
    var body: some View {
        
        ZStack{
            previewView
            CameraResultView(textElements: recognizer.foundElements, convert: convert, recognizer: recognizer, outputType: outputType)

        }
        .ignoresSafeArea()
        .overlay(alignment: .top, content: {
            Text(recognizer.state.prompt)
                .padding(3)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top, 5)
        })
        .overlay(alignment: .bottom, content: {
            VStack{
                CameraShutterButton(action: {
                    
                })
                CameraControllsView(useROI: $recognizer.useROI, convert: $convert, outputType: $outputType, onDismissPressed: {
                    
                    if let selectedTextElement = selectedTextElement {
                        holder.input = selectedTextElement.text
                    }
                    else if let first=recognizer.foundElements.first(where: {$0.type.isNumber}){
                        holder.input = first.text
                    }
                    dismiss()
                })
            }
            
                
        })
        .gesture(MagnificationGesture().onChanged { val in
            let delta = val / self.lastScaleValue
            self.lastScaleValue = val
            let newScale = self.zoomScale * delta
            self.zoomScale = newScale
            
        }.onEnded { val in
            self.lastScaleValue = 1.0
        })
 
    }
    
    
    
    
    var previewView:some View{
        let h=PreviewHolder(recognizer: recognizer, zoomScale: $zoomScale)
        let width=CGFloat(700)
        #if os(macOS)
        return h.frame(minWidth: width, maxWidth: .infinity, minHeight: width/recognizer.videoAspectRatio, maxHeight: .infinity, alignment: .center)
        #else
        return h
        #endif
            
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
