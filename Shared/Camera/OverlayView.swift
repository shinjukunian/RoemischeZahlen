//
//  OverlayView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/03.
//

import SwiftUI

extension Recognizer.TextElement.TextElementType{
    var fillColor:Color{
        let color:Color
        switch self {
        case .arabicNumber:
            color=Color.red
        case .japaneseNumber:
            color=Color.green
        case .romanNumeral:
            color=Color.orange
        case .other:
            color=Color.clear
        }
        return color.opacity(0.2)
    }
    
    var strokeColor:Color{
        let color:Color
        switch self {
        case .arabicNumber:
            color=Color.red
        case .japaneseNumber:
            color=Color.green
        case .romanNumeral:
            color=Color.orange
        case .other:
            color=Color.gray
        }
        return color.opacity(0.8)
    }
    
}


struct OverlayView: View {
    
    enum OutputType{
        case none
        case transform(output:Output)
        case highlight
    }
    
    
    @State var element:Recognizer.TextElement
    @State var outputType = OutputType.highlight
    
    var body: some View {
        makeView()
            .contentShape(Rectangle()) 
            .onTapGesture(perform: {
                print("tap")
        })
    }
    
    @ViewBuilder
    func makeView()-> some View{
        switch self.outputType {
        case .highlight:
            ZStack(content: {
                Rectangle()
                    .stroke(element.type.strokeColor, lineWidth: 1)
                    .background(element.type.fillColor)
            })
            
        case .transform(let output):
           
                ZStack(content: {
                    
                    if let converted=self.element.convert(output: output){
                        Rectangle()
                            .stroke(element.type.strokeColor, lineWidth: 1)
                            .background(Color.white.opacity(0.9))
                        Text(converted)
                            .foregroundColor(Color.black)
                            .fontWeight(.heavy)
                    }
                    else{
                        Text(element.text)
                    }
                    
                })
            
            
            
        case .none:
             EmptyView()
        }
    }
    
    
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView(element: Recognizer.TextElement(text: "125", rect: .zero), outputType: .transform(output: .römisch))
    }
}
