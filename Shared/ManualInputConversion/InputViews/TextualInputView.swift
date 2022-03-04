//
//  TextualInputView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import SwiftUI
import XLIICore

struct TextualInputView: View {
    @Binding var stringValue:String
    
    let provider:ButtonProviding
    
    var body: some View {
        VStack{
            ForEach(Array(zip(provider.buttonValues,provider.values)), id:\.0, content:{items in
                
                HStack{
                    ForEach(Array(zip(items.0,items.1)), id:\.0, content: {(text:String, numericalValue:Int) in
                        Button(action: {
                            let new=stringValue + text
                            stringValue = provider.formattingHandler(new)
                        }, label: {
                            VStack{
                                Text(text)
                                    .fontWeight(.bold)
                                Text(numericalValue.formatted())
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }
                            .frame(minWidth:30, maxWidth: 50)
                            .frame(minHeight: 30, maxHeight:40)
                            
                        }).buttonStyle(.bordered)
                            
                    })
                }
            })
        }
    }
}

struct TextualInputView_Previews: PreviewProvider {
    static var previews: some View {
        let buttons=Output.hieroglyph.buttons!
        TextualInputView(stringValue: .constant(""), provider: buttons)
    }
}
