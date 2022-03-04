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
            ForEach(Array(zip(provider.buttonValues,provider.buttonLabels)), id:\.0, content:{items in
                
                HStack{
                    ForEach(Array(zip(items.0,items.1)), id:\.0, content: {(text:String, label:String) in
                        
                            makeButton(text: text, label: label)
                    })
                }
            })
        }
    }
    
    func makeButton(text:String, label:String)->some View{
        Button(action: {
            let new=stringValue + text
            stringValue = provider.formattingHandler(new)
        }, label: {
            VStack{
                Text(text)
                    .fontWeight(.bold)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .frame(minWidth:30, maxWidth: 50)
            .frame(minHeight: 30, maxHeight:40)
            
        })
        #if os(iOS)
            .buttonStyle(.bordered)
        #else
            .buttonStyle(InputViewButtonStyle())
        #endif
    }
    
}

struct TextualInputView_Previews: PreviewProvider {
    static var previews: some View {
        let buttons=Output.japanisch_bank.buttons!
        TextualInputView(stringValue: .constant(""), provider: buttons)
    }
}
