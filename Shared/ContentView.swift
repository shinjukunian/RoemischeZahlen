//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var holder:NumeralConversionHolder
    
//    @FocusState private var textFieldIsFocused: Bool

    var textField:some View{
        let t=TextField(LocalizedStringKey("Number"), text: $holder.input)
        .textFieldStyle(RoundedBorderTextFieldStyle())
//        .focused($textFieldIsFocused)
        #if os(macOS)
            return t
        #else
        return t.keyboardType(.numbersAndPunctuation)
        #endif
    }
    
    var picker: some View{
        let p=Picker(selection: $holder.outputMode, label: Text("Output"), content: {
            Text("Roman").tag(Output.römisch)
            Text("Japanese").tag(Output.japanisch)
            Text("Japanese (大字)").tag(Output.japanisch_bank)
            
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
                })
                
                
                VStack(alignment: .center, spacing: 12.0){
                    
                    VStack(spacing: 12.0){
                        textField.padding(.horizontal)
                        
                        
                        if holder.formattedNumericInput != nil{
                            GroupBox{
                                Text(holder.formattedNumericInput!)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        else{
                            EmptyView()
                        }
                        
                        
                        
                        GroupBox{
                                Text(holder.formattedOutout)
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
                                        .disabled(holder.isValid == false)
                                        
                                    }))
                            }
                            
                        
                        
                        
                    }
                    
                    buttons
                }
            }
            
            .padding(.all)
            .fixedSize()
            #if !os(macOS)
            Spacer()
            #endif
            
        }
        .userActivity(NSUserActivity.ActivityTypes.conversionActivity, isActive: holder.isValid, { activity in
            activity.isEligibleForHandoff = true
            do{
                activity.title = self.holder.input
                try activity.setTypedPayload(holder.info)

            }
            catch let error{
                print(error.localizedDescription)
            }
        })
        .onContinueUserActivity(NSUserActivity.ActivityTypes.conversionActivity, perform: { userActivity in
            print("restoring \(userActivity.activityType)34")
            do{
                let payload=try userActivity.typedPayload(NumeralConversionHolder.ConversionInfo.self)
                holder.info=payload
            }
            catch let error{
                print(error.localizedDescription)
            }
            
        })
        .onAppear(perform:{
//            textFieldIsFocused=true
        })
    }
    
    @ViewBuilder
    var buttons:some View{
        HStack(spacing: 16, content: {
            Button(action: {
                holder.speak()
            }, label: {
                Image(systemName: "play.rectangle.fill")
            })
            .disabled(holder.input.isEmpty)
            .keyboardShortcut(KeyEquivalent("s"), modifiers: [.command,.option])
            .help(Text("Speak"))
            
            Button(action: {
                putOnPasteBoard()
                
            }, label: {
                Image(systemName: "arrow.right.doc.on.clipboard")
            })
            .disabled(holder.input.isEmpty)
            .help(Text("Copy"))
            .keyboardShortcut(KeyEquivalent("c"), modifiers: [.command])
            
        })
        
    }
    
    func putOnPasteBoard(){
        #if os(macOS)
            NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(holder.output, forType: .string)
        #else
        UIPasteboard.general.string=holder.formattedOutout
        #endif
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(holder: NumeralConversionHolder())
            
        }
            
    }
}
