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
    case japanisch_bank
    
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
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
        #if os(macOS)
            return t
        #else
        return t.keyboardType(.numbersAndPunctuation)
        #endif
    }
    
    var picker: some View{
        let p=Picker(selection: $outputMode, label: Text("Output"), content: {
            Text("Römisch").tag(Output.römisch)
            Text("Japanisch").tag(Output.japanisch)
            Text("Japanisch (大字)").tag(Output.japanisch_bank)
        }).fixedSize()
       
        #if os(macOS)
        return p.pickerStyle(InlinePickerStyle())
        #else
        return p.pickerStyle(SegmentedPickerStyle()).fixedSize()
        #endif
        
        
    }
    
    
    var body: some View {
        VStack{
            GroupBox{
                VStack(alignment: .center, spacing: 9.0, content: {
                    picker.onReceive(Just(outputMode), perform: { _ in
                        self.parse(input: self.input)
                    })
                    Divider()
                    HStack(alignment: .center){
                        
                        VStack{
                            textField
                            Text(output)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: {
                                        putOnPasteBoard()
                                    }, label: {
                                        Text("Copy")
                                    })
                                    .help(Text("Speak"))
                                    
                                }))
                        }.frame(maxWidth:300)
                        
                        VStack(spacing: 8.0, content: {
                            Button(action: {
                                formatter.speak(input: SpeechOutput(text: input), output: SpeechOutput(text: output))
                                
                            }, label: {
                                Image(systemName: "play.rectangle.fill")
                            })
                            .disabled(output.isEmpty)
                            .keyboardShortcut(KeyEquivalent("s"), modifiers: [.command,.option])
                            
                            Button(action: {
                                putOnPasteBoard()
                                
                            }, label: {
                                Image(systemName: "arrow.right.doc.on.clipboard")
                            })
                            .disabled(output.isEmpty)
                            .help(Text("Copy"))
                            .keyboardShortcut(KeyEquivalent("c"), modifiers: [.command])
                            
                        })
                    }
                    
                    

                })
            }
            
            .padding(.all)
            
            Spacer()
        }
        
        
        
    }
    
    func putOnPasteBoard(){
        #if os(macOS)
            NSPasteboard.general.declareTypes([.string], owner: nil)
            NSPasteboard.general.setString(output, forType: .string)
        #else
            UIPasteboard.general.string=output
        #endif
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
            case .japanisch_bank:
                output = formatter.macheJapanischeBankZahl(aus: zahl) ?? ""
            }
            
            
        }
        else if let arabisch = formatter.macheZahl(aus: input){
            let f=NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits=0
            output = f.string(from: NSNumber(integerLiteral: arabisch)) ?? ""
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
