//
//  Settings.swift
//  RoemischeZahl (macOS)
//
//  Created by Morten Bertz on 2021/09/14.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiComplete = false
    
    var body: some View {
        Form(content: {
            Toggle(isOn: $daijiComplete, label: {
                Text("Complete Daiji Conversion")
                    .help(Text("Convert all characters to Daiji. This usage is archaic."))
            })
        })
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
