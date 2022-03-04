//
//  ConversionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/03.
//

import SwiftUI
import XLIICore

struct ConversionDetailView: View {
    
    @EnvironmentObject var holder:ConversionDetailHolder
    
    @State var showDecimals=true
    @State var showOther=true
    
    var body: some View {
        VStack{
            GroupBox{
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        Text(holder.outputDescription)
                        Text("↔︎").foregroundColor(.accentColor)
                        Text(Output.numeric(base: 10).description)
                        Spacer()
                    }.font(.title3)
                    Divider()
                    HStack{
                        Spacer()
                        ConversionDetailResultView().environmentObject(holder)
                        Spacer()
                        clearButton
                    }

                }
            }.padding()
            
            inputView.padding(.horizontal)
               

            
            Spacer()
        }
    }
    
    @ViewBuilder
    var inputView:some View{
        
        VStack(alignment: .center, spacing: 12.0){
            HStack{
                Spacer()
                Picker(selection: $holder.input, content: {
                    Text(holder.output.description).tag(ConversionDetailHolder.Input.textual)
                    Text(Output.numeric(base: 10).description).tag(ConversionDetailHolder.Input.decimal)
                }, label: {})
                    .pickerStyle(.segmented)
                Spacer()
            }
            
            switch holder.input{
            case .decimal:
                DecimalInputView(value: $holder.numericalInput)
            case .textual:
                if let buttons=holder.output.buttons{
                    TextualInputView(stringValue: $holder.textualInput, provider: buttons)
                }
                else{
                    EmptyView()
                }
                
            }
        }
        
        
    }
   
    
    var clearButton:some View{
        Button(role: .destructive, action: {
            holder.clear()
        }, label: {
            Label(title: {
//                Text("Clear")
            }, icon: {
                Image(systemName: "clear")
            })
        })
            .keyboardShortcut(.delete, modifiers: [])
        #if os(macOS)
            .buttonStyle(.borderless)
        #endif
    }
    
}

struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
        ConversionDetailView().environmentObject(ConversionDetailHolder(output: .glagolitic))
    }
}
