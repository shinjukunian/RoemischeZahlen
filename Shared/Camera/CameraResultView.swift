//
//  CameraResultView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/05.
//

import SwiftUI
import XLIICore

struct CameraResultView: View {
    
    let textElements:[Recognizer.TextElement]
    let convert:Bool
    let outputType:Output
    let aspectRatio:Double
    let ROI:CGRect?
    
    @Binding var selectedElement:Recognizer.TextElement?
    
    var body: some View {
        GeometryReader(content: { geometry in
            makeOverlay(size: geometry.size, elements: self.textElements)
                
        })
    }
    
    func makeOverlay(size:CGSize, elements:[Recognizer.TextElement])->some View{
        
        let aspect=aspectRatio
        let currentAspect=size.width / size.height
        let outSize:CGSize
    
        if currentAspect < aspect{
            outSize = CGSize(width: size.width, height: size.width / aspect)
        }
        else{
            outSize = CGSize(width: size.height * aspect, height: size.height)
        }
        let origin=CGPoint(x: (size.width - outSize.width)/2, y: (size.height - outSize.height)/2)
        
        let output:OverlayView.OutputType
        let displayElements:[Recognizer.TextElement]
        if self.convert{
            output = .transform(output: self.outputType)
            displayElements=elements.filter({$0.type != .other})
        }
        else{
            output = .highlight
            displayElements = elements
        }
        
        
        return GeometryReader(content: { geometry in
            if let ROI = ROI {
                ROIView(roiRect: ROI)
            }
            ForEach(displayElements, id: \.rect, content: {element in
                let width=geometry.size.width * element.rect.width
                let height=geometry.size.height * element.rect.height
                
                let x=geometry.size.width * element.rect.minX
                let y=geometry.size.height - geometry.size.height * element.rect.minY - height
                if convert{
                    OverlayView(element: element, outputType: output)
                        .offset(x: x, y: y)
                        
                    
                }
                else{
                    OverlayView(element: element, outputType: output)
                        .offset(x: x, y: y)
                        .frame(width: width, height: height, alignment: .topLeading)
                        
                        
                }
            })
        })
        .offset(x: origin.x, y: origin.y).frame(width: outSize.width, height: outSize.height, alignment: .topLeading)
        
            
    }
}

struct CameraResultView_Previews: PreviewProvider {
    static var previews: some View {
        CameraResultView(textElements: [Recognizer.TextElement](), convert: true, outputType: .japanisch, aspectRatio: 1, ROI: nil, selectedElement: .constant(nil))
    }
}
