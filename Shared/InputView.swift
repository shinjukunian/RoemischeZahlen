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
    
    @AppStorage(UserDefaults.Keys.preferredBasesKey) var historyData = HistoryPreference.empty.rawValue
    
    @AppStorage(UserDefaults.Keys.preferredBasesKey) var preferredBases:BasePreference = .default
    
    var body: some View {
        
        VStack{
            let history=(HistoryPreference(rawValue: historyData) ?? .empty)
            InputTextField(text: $holder.input, historyItems: history.items, textFieldIsFocused: textFieldIsFocused, onSubmit: {
                guard holder.state == .valid else{
                    return
                }
                historyData = HistoryPreference.updateHistory(history: history, items: [.init(text: holder.input)]).rawValue
            })
            OutputView(holder: holder)
            Spacer()
            
        }
        .padding(.horizontal)
        .userActivity(NSUserActivity.ActivityTypes.conversionActivity, isActive: holder.state == .valid, { activity in
            
            activity.isEligibleForHandoff = true

            do{
                activity.title = holder.input
                try activity.setTypedPayload(ConversionInputHolder.Payload(text: holder.input, numeric: holder.selectedResult.value))
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

}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="8"
        return InputView(holder: holder)
    }
}
