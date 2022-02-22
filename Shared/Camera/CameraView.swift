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
    @State var zoomScale: CGFloat = 4.0
    
    #if os(macOS)
    @State var useROI: Bool = true
    #else
    @State var useROI: Bool = true
    #endif
    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedTextElement:Recognizer.TextElement?
    
    var body: some View {
        
        ZStack{
            previewView
            GeometryReader(content: { geometry in
                makeOverlay(size: geometry.size, elements: self.textElements)
                    .onReceive(recognizer.$foundElements, perform: { elements in
                        self.textElements=elements
                    })
            })
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
            controls
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(.ultraThinMaterial)
        })
        .gesture(MagnificationGesture().onChanged { val in
            let delta = val / self.lastScaleValue
            self.lastScaleValue = val
            let newScale = self.zoomScale * delta
            self.zoomScale = newScale
            
        }.onEnded { val in
            self.lastScaleValue = 1.0
        })
        .onAppear{
            recognizer.useROI=useROI
        }
 
    }
    
    var controls: some View{
        HStack(alignment: .center, spacing: 12){
            VStack{
                Toggle(isOn: $convert){
                    Text("Convert")
                }.fixedSize()
//#if os(macOS)
                Toggle(isOn: $useROI){
                    Text("Use ROI")
                }.fixedSize()
//#endif
                
            }
            
            Picker(selection: $outputType, label: Text("Output"), content: {
                ForEach(Output.builtin + Output.numericTypes, id: \.self, content: {output in
                    Text(verbatim: output.description)
                        .lineLimit(3)
                        .tag(output)
                })
            })
            .pickerStyle(.menu)
            .disabled(convert == false)
            .fixedSize(horizontal: true, vertical: true)
            Spacer()

            Button(role: .cancel, action: {
                dismiss()
            }, label: {
                Text("Dismis")
            }).buttonStyle(.bordered)


        }.onChange(of: useROI, perform: {useROI in
            recognizer.useROI=useROI
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
            if self.useROI{
                ROIView(roiRect: recognizer.defaultRegionOfInterest)
            }
            
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
