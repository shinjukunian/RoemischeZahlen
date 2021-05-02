//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI
import Combine

enum Output: String, CaseIterable, Identifiable{
    case römisch
    case japanisch
    case arabisch
    
    var id: String { self.rawValue }
}


struct ContentView: View {
    
    @State var input:String = ""
    @State var output:String = ""
    
    @State var outputMode:Output = Output.römisch
    
    let formatter=ExotischeZahlenFormatter()
    
    var textField:some View{
        let t=TextField(LocalizedStringKey("Number"), text: $input, onEditingChanged: {_ in}, onCommit: {
            self.parse(input: input)
            
        }).onReceive(Just(input), perform: {text in
            self.parse(input: text)
        })
        .frame(minWidth: nil, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: 100, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: nil, maxHeight: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
        #if os(macOS)
            return t
        #else
        return t.keyboardType(.numberPad)
        #endif
    }
    
    var picker: some View{
        let p=Picker("Output", selection: $outputMode, content: {
            Text("Römisch").tag(Output.römisch)
            Text("Japanisch").tag(Output.japanisch)
        })
        #if os(macOS)
        return p.pickerStyle(InlinePickerStyle())
        #else
        return p.pickerStyle(SegmentedPickerStyle()).padding()
        #endif
        
        
    }
    
    
    var body: some View {
        ZStack(content: {
            
            VStack(alignment: .center, spacing: 5, content: {
                picker.onReceive(Just(outputMode), perform: { _ in
                    self.parse(input: self.input)
                })
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5, content: {
                    textField
                }).padding()
                HStack(content: {
                    Text(output).multilineTextAlignment(.center)
                    .lineLimit(1)
                        .fixedSize()
                        .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                        .padding()
                        .contextMenu(ContextMenu(menuItems: {
                            Button(action: {
                                #if os(macOS)
                                    NSPasteboard.general.declareTypes([.string], owner: nil)
                                    NSPasteboard.general.setString(output, forType: .string)
                                #else
                                    UIPasteboard.general.string=output
                                #endif
                            }, label: {
                                Text("Copy")
                            })
                            .help(Text("Speak"))
                            
                        }))
                    Button(action: {
                        formatter.speak(input: SpeechOutput(text: input), output: SpeechOutput(text: output))
//                        if Int(output) != nil{
//
//                        }
//                        else{
//                            formatter.speak(input: ExotischeZahlenFormatter.SpeechOutput(format: .auto, text: input), output: ExotischeZahlenFormatter.SpeechOutput(format: outputMode, text: output))
//
//                        }
                        
                    }, label: {
                        Image(systemName: "play.rectangle.fill")
                    })
                    .disabled(output.isEmpty)
                    .keyboardShortcut(KeyEquivalent("s"), modifiers: [.command,.option])
                })
                .padding(.horizontal)
                Spacer()
                
            })
            .padding(.top)
            
            
        })
       
    
    }
    
    
    func parse(input:String){
        guard input.isEmpty == false else{
            output = ""
            return
        }
        
        if let zahl = Int(input){
            switch outputMode {
            case .römisch:
                output = formatter.macheRömischeZahl(aus: zahl) ?? ""
            case .japanisch:
                output = formatter.macheJapanischeZahl(aus: zahl) ?? ""
            case .arabisch:
                output = input
            }
            
        }
        else if let arabisch = formatter.macheZahl(aus: input){
            output = String(arabisch)
        }
        else{
            output = ""
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
