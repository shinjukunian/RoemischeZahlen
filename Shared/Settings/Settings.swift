//
//  Settings.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import SwiftUI

#if os(iOS)
import MessageUI
#endif

struct SettingsView: View {
    
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiForAll:Bool = false
    @Environment(\.dismiss) var dismiss
    @AppStorage(UserDefaults.Keys.allowBasesBesides10Key) var otherBases:Bool = true
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        
            Form{
                Section(content: {
                    Toggle(isOn: $daijiForAll, label: {Text("Convert all characters to  Daiji")})
                        .help(Text("Convert all characters to Daiji. This usage is archaic."))
                    
                    Toggle(isOn: $otherBases, label: {Text("Allow bases other than 10 for numeric input")})
                        .help(Text("Parse numeric input for other bases, e.g. binary or hexadecimal."))
                    
                }, header: {
                    Text("Formatting")
                })
                
#if os(iOS)
                Section(content: {
                    NavigationLink(destination: {
                        
                        MailView(result: .constant(nil))
                        
                    }, label: {
                        Text("Feedback")
                    })
                    
                    .disabled(!MFMailComposeViewController.canSendMail())
                    
                }, header: {
                    Text("Feedback")
                })
                
#endif
            }
            .navigationTitle(Text("Settings"))
#if os(iOS)
            .navigationViewStyle(.stack)
           
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(action: {
                        dismiss()
                    }, label: {Text("Done")})
                })
            })
#endif
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
