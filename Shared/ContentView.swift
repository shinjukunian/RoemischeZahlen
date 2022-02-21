//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    
#if os(iOS)
    @FocusState private var textFieldIsFocused: Bool
#endif
    
    @State var showLanguageSelection = false
    
    
    
    var textField:some View{
        let t=TextField(LocalizedStringKey("Enter Number"), text: $holder.input)
        .textFieldStyle(RoundedBorderTextFieldStyle())
       
        #if os(macOS)
        return t
        #else
            return t
            .focused($textFieldIsFocused)
            .keyboardType(.numbersAndPunctuation)
        #endif
    }
    

    var body: some View {
        
        VStack{
            GroupBox{
                VStack{
                    textField.padding(.horizontal)
                    Divider().background(Color.accentColor)
                    switch holder.inputType{
                    case .empty:
                        EmptyView()
                    case .invalid:
                        GroupBox{
                            Text("The input could not be parsed.")
                        }
                    case .textual(let output):
                        let validOutputs=holder.outputs.filter({$0 != output})
                        let items=[Output.arabisch, Output.currentLoale] + validOutputs
                        ConversionTableView(holder: holder, displayItems: items)
                    case .arabic:
                        let items=[Output.currentLoale] + holder.outputs
                        ConversionTableView(holder: holder, displayItems: items)
                    }
                    Spacer()
                    Button(action: {
                        showLanguageSelection=true
                    }, label: {
                        Image(systemName: "plus.rectangle")
                    }).disabled(holder.numericInput == nil)
                    
                }
                
                Spacer()
                
            }
            .padding(.all)
//            .fixedSize(horizontal: false, vertical: true)
            #if os(iOS)
            Spacer()
            #else
                
            #endif
            
        }
        .userActivity(NSUserActivity.ActivityTypes.conversionActivity, isActive: holder.inputType != .invalid, { activity in
            activity.isEligibleForHandoff = true
            do{
                activity.title = self.holder.input
                try activity.setTypedPayload(holder.input)

            }
            catch let error{
                print(error.localizedDescription)
            }
        })
        .onContinueUserActivity(NSUserActivity.ActivityTypes.conversionActivity, perform: { userActivity in
            print("restoring \(userActivity.activityType)")
            do{
                let payload=try userActivity.typedPayload(String.self)
                holder.input=payload
            }
            catch let error{
                print(error.localizedDescription)
            }
            
        })
        .onAppear(perform:{
#if os(iOS)
            textFieldIsFocused=true
#endif
        })
        .sheet(isPresented: $showLanguageSelection, onDismiss: {}, content: {
            OutputSelectionView(holder: holder)
        })
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(holder: ConversionInputHolder())
            
        }
            
    }
}



