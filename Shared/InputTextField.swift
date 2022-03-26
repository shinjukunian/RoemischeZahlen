//
//  InputTextField.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/25.
//

import SwiftUI

struct InputTextField: View {
    
    @Binding var text:String
    
    let historyItems:[HistoryItem]
    
    let textFieldIsFocused:Bool
    let onSubmit: (()->Void)?
    
    var body: some View {
        textField.onSubmit(of: .text, {
            (onSubmit ?? {})()
        })
    }
    
    var textField: some View{
        let t=TextField(LocalizedStringKey("Enter Number"), text: $text)
            .textFieldStyle(.roundedBorder)
            .overlay(alignment: .trailing, content: {
                Menu(content: {
                    ForEach(historyItems.prefix(10), content: {item in
                        Button(action: {
                            text = item.text
                        }, label: {
                            HStack{
                                Text(verbatim: item.text)
                            }
                        })
                    })
                }, label: {
                    Image(systemName: "building.columns")
                }).disabled(historyItems.isEmpty)
                    .fixedSize(horizontal: true, vertical: false)
                    .menuStyle(.borderlessButton)
                    .padding(.trailing)
                    .tint(.secondary)

            })
#if os(macOS)
        return t
#else
        return t.keyboardType(.numbersAndPunctuation)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(textFieldIsFocused ? Color.accentColor : .clear, lineWidth: 0.75))
#endif
    }
    
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField(text: .constant("test"),
                       historyItems: [.init(text: "100"), .init(text: "MMC")],
                       textFieldIsFocused: true, onSubmit: nil)
    }
}
