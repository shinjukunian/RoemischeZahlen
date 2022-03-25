//
//  DecimalInputView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/03.
//

import SwiftUI

struct DecimalInputView: View {

    @Binding var value:Int
    
    let buttonValues = [[7,8,9],[4,5,6],[1,2,3], [0]]
    
    
    var body: some View {
        
        VStack{
            ForEach(buttonValues, id:\.self, content:{numbers in
                HStack{
                    ForEach(numbers, id:\.self, content: {idx in
                        Button(action: {
                            value *= 10
                            value += idx
                            
                        }, label: {
                            Text(String(idx))
                                .fontWeight(.bold)
                                .frame(minWidth:40, maxWidth: 50)
                                .frame(minHeight: 40, maxHeight:40)
                        })
                        #if os(macOS)
                            .buttonStyle(InputViewButtonStyle())
                        #else
                            .buttonStyle(.bordered)
                        #endif
                            
                            
                    })
                }
            })
        }
    }
    
    
    
}

struct DecimalInputView_Previews: PreviewProvider {
    static var previews: some View {
        DecimalInputView(value: .constant(0))
    }
}


struct InputViewButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8).strokeBorder(configuration.isPressed ? .primary : .secondary)
            })
            .background(self.background(configuration: configuration))
    }
    
    @ViewBuilder
    private func background(configuration:Configuration)->some View{
        if configuration.isPressed{
             RoundedRectangle(cornerRadius: 8).fill(.selection)
        }
        else{
             RoundedRectangle(cornerRadius: 8).fill(.ultraThickMaterial)
        }
    }
}
