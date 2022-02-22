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
    @AppStorage(UserDefaults.Keys.allowBasesBesides10Key) var otherBases:Bool = false
    
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
#else
                Section(content: {
                    openURLButton
                }, header: {})
                
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
    var openURLButton:some View{
        Button(action: {
            let bundle=Bundle.main
            let name=bundle.applicationName
            let version=bundle.version
            let osVersion=ProcessInfo.processInfo.operatingSystemVersionString
            let subject=NSLocalizedString("Feedback \(name) (\(version)) [MacOS \(osVersion)]", comment: "Feedback subject string")
            let subjectString="SUBJECT="+subject.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let receiver="support@telethon.jp".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let mailString="mailto:"+receiver+"?"+subjectString+"&"+""
            let url=URL(string: mailString)!
            openURL(url)
        }, label: {
            Text("Send Feedback")
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
