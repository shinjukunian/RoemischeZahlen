//
//  Settings.swift
//  RoemischeZahl (macOS)
//
//  Created by Morten Bertz on 2021/09/14.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiComplete = false
    
    @AppStorage(UserDefaults.Keys.outPutModeKey) var outputMode = Output.römisch
    
    var body: some View {
        Form(content: {
            
            Toggle(isOn: $daijiComplete, label: {
                Text("Convert all characters to  Daiji")
                    .help(Text("Convert all characters to Daiji. This usage is archaic."))
            })
            
            picker
            
            
            
        })
        .padding()
        
    }
    
    
    var picker: some View{
        let p=Picker(selection: $outputMode, label: Text("Output Format"), content: {
            Text("Roman").tag(Output.römisch)
            Text("Japanese").tag(Output.japanisch)
            Text("Japanese (大字)").tag(Output.japanisch_bank)
        })
        #if os(macOS)
        return p.fixedSize()
        #else
        return p
        #endif
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
