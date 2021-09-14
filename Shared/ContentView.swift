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
    
    @AppStorage(UserDefaults.Keys.outPutModeKey) var outputMode:Output = Output.römisch
    
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiComplete = false
    
    let formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    
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
                VStack(alignment: .center, spacing: 12, content: {
                    picker
                        .onReceive(Just(outputMode), perform: { _ in
                        self.parse(input: self.input)
                    })
                    
                    Divider()
                    VStack(alignment: .center, spacing: 12.0){
                        
                        VStack(spacing: 12.0){
                            textField
                            GroupBox{
                                Text(output)
                                    .font(.title)
                                    .fontWeight(.bold)
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
                            }
                            
                            
                        }
                        
                        HStack(spacing: 16, content: {
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
            .fixedSize()
//            #if os(macOS)
            Spacer()
//            #endif
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
            output = NSLocalizedString("No Input", comment: "")
            return
        }
        
        if let zahl = Int(input){
            switch outputMode {
            case .römisch:
                output = formatter.macheRömischeZahl(aus: zahl) ?? noValidNumber
            case .japanisch:
                output = formatter.macheJapanischeZahl(aus: zahl) ?? noValidNumber
            case .arabisch:
                output = input
            case .japanisch_bank:
                output = formatter.macheJapanischeBankZahl(aus: zahl, einfach: !daijiComplete) ?? noValidNumber
            }
            
            
        }
        else if let arabisch = formatter.macheZahl(aus: input){
            let f=NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits=0
            output = f.string(from: NSNumber(integerLiteral: arabisch)) ?? noValidNumber
        }
        else{
            output = noValidNumber
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
