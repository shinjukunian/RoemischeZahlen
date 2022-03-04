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
    
//    @State var decade = 1
    
    var body: some View {
        
        VStack{
            ForEach(buttonValues, id:\.self, content:{numbers in
                HStack{
                    ForEach(numbers, id:\.self, content: {idx in
                        Button(action: {
//                            decade *= 10
                            value *= 10
                            value += idx
                            
                        }, label: {
                            Text(String(idx))
                                .fontWeight(.bold)
                                .frame(minWidth:40, maxWidth: 50)
                                .frame(minHeight: 40, maxHeight:40)
                        }).buttonStyle(.bordered)
                            
                            
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
