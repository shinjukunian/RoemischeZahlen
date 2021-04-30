//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI

struct ContentView: View {
    
    @State var input:String = ""
    @State var roemisch:String = ""
    
    let formatter=RömischeZahl()
    
    var textField:some View{
        let t=TextField(LocalizedStringKey("Number"), text: $input, onEditingChanged: {_ in}, onCommit: {
            if let zahl = Int(input){
                roemisch = formatter.macheRömischeZahl(aus: zahl) ?? ""
            }
            else if let arabisch = formatter.macheZahl(aus: input){
                roemisch = String(arabisch)
            }
            else{
                roemisch = ""
            }
            
        }).frame(minWidth: nil, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: 100, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: nil, maxHeight: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
        #if os(macOS)
            return t
        #else
        return t.keyboardType(.numberPad)
        #endif
    }
    
    
    var body: some View {
        ZStack(content: {
            
            VStack(alignment: .center, spacing: 5, content: {
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5, content: {
                    textField
                }).padding()
                HStack(content: {
                    Text(roemisch).multilineTextAlignment(.center).lineLimit(1)
                        .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                        .padding()
                        .contextMenu(ContextMenu(menuItems: {
                            Button(action: {
                                #if os(macOS)
                                NSPasteboard.general.declareTypes([.string], owner: nil)
                                NSPasteboard.general.setString(roemisch, forType: .string)
                                #else
                                UIPasteboard.general.string=self.roemisch
                                #endif
                            }, label: {
                                Text("Copy")
                            })
                            .help(Text("Speak"))
                            
                        }))
                    Button(action: {
                        formatter.speak(input: input, roman: roemisch)
                    }, label: {
                        Image(systemName: "play.rectangle.fill")
                    })
                })
                .padding(.horizontal)
                
                
            })
            .padding(.top)
            
        })
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
