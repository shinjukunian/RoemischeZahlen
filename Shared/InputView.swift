//
//  InputView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/22.
//

import SwiftUI

struct InputView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        
        VStack{
            textField
            OutputView(holder: holder)
            
            Spacer()
            
        }.padding(.horizontal)
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
        
        
        
    }
    
    
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
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="8"
        return InputView(holder: holder)
    }
}
