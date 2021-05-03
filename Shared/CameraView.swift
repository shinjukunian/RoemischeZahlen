//
//  CameraView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import SwiftUI
import Combine

struct CameraView: View {
    
    @StateObject var recognizer=Recognizer()
    @State var textElements=[Recognizer.TextElement]()
    @State var outputType:Output = .japanisch
    
    @State var convert:Bool = true
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var zoomScale: CGFloat = 1.0
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 5.0){
                Toggle("Convert", isOn: $convert)
                    .padding(.trailing)
                
                Picker("Output", selection: $outputType, content: {
                    Text("Römisch").tag(Output.römisch)
                    Text("Japanisch").tag(Output.japanisch)
                })
                .pickerStyle(SegmentedPickerStyle())
                .disabled(convert == false)
                .fixedSize()
                
            }
            .padding([.top, .leading, .trailing])
            Text(recognizer.state.prompt)
                .multilineTextAlignment(.center)
            ZStack{
                PreviewHolder(recognizer: recognizer, zoomScale: $zoomScale)
                    .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
                GeometryReader(content: { geometry in
                    makeOverlay(size: geometry.size, elements: self.textElements)
                        .onReceive(recognizer.$foundElements, perform: { elements in
                            self.textElements=elements
                        })
                })
            }
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                let newScale = self.zoomScale * delta
                self.zoomScale = newScale
                //... anything else e.g. clamping the newScale
            }.onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            }
            )
            
            
            
        }
    }
    
    
    func makeOverlay(size:CGSize, elements:[Recognizer.TextElement])->some View{
        
        let aspect=recognizer.videoAspectRatio
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
        if self.convert{
            output = .transform(output: self.outputType)
        }
        else{
            output = .highlight
        }
        
        return GeometryReader(content: { geometry in
//            Rectangle().fill(Color.blue.opacity(0.2))
            ForEach(elements, id: \.rect, content: {element in
                let width=geometry.size.width * element.rect.width
                let height=geometry.size.height * element.rect.height
                
                let x=geometry.size.width * element.rect.minX
                let y=geometry.size.height - geometry.size.height * element.rect.minY - height
                
                OverlayView(element: element, outputType: output)
                    .offset(x: x, y: y)
                    .frame(width: width, height: height, alignment: .topLeading)

                
            })
        }).offset(x: origin.x, y: origin.y).frame(width: outSize.width, height: outSize.height, alignment: .topLeading)
    }
    
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
