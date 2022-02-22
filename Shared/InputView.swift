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
    @Namespace var mainNamespace
    
    var body: some View {
        
        VStack{
            textField
            OutputView(holder: holder)
            Spacer()
            
        }
        .padding(.horizontal)
        .userActivity(NSUserActivity.ActivityTypes.conversionActivity, isActive: [ConversionInputHolder.InputType.empty, .invalid].contains(holder.inputType) == false , { activity in
            activity.isEligibleForHandoff = true
            
            do{
                activity.title = self.holder.input
                try activity.setTypedPayload(ConversionInputHolder.Payload(text: self.holder.input, numeric: self.holder.numericInput ?? 0))
                activity.needsSave=true
                activity.becomeCurrent()
                #if DEBUG
                print("saving user activity \(activity.title ?? "")")
                #endif
            }
            catch let error{
                print(error.localizedDescription)
            }
        })
        .onContinueUserActivity(NSUserActivity.ActivityTypes.conversionActivity, perform: { userActivity in
            print("restoring \(userActivity.activityType)")
            do{
                let payload=try userActivity.typedPayload(ConversionInputHolder.Payload.self)
                holder.input=payload.text
            }
            catch let error{
                print(error.localizedDescription)
            }
            
        })
        .onAppear(perform:{
            textFieldIsFocused=true
        })
        
        
        
    }
    
    
    var textField:some View{
        let t=TextField(LocalizedStringKey("Enter Number"), text: $holder.input)
            .textFieldStyle(.roundedBorder)
            
            .focused($textFieldIsFocused)
            
#if os(macOS)
        return t
            .prefersDefaultFocus(in: mainNamespace)
#else
        return t
            .keyboardType(.numbersAndPunctuation)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(textFieldIsFocused ? Color.accentColor : .clear, lineWidth: 0.75))
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
