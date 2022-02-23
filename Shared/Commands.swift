//
//  Commands.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/23.
//

import Foundation
import SwiftUI


struct FeedbackButton : Commands{
    
    @Environment(\.openURL) var openURL
    
    var body: some Commands{
        CommandGroup(after: .help, addition: {
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
                Text("Feeedback")
            })
        })
    }
}

struct SidebarButton: View{
    
    @Binding var showSideBar:Bool
    
    var body: some View{
        Button(action: {
            withAnimation{
                showSideBar.toggle()
            }
        }, label: {
            Label(title: {
                showSideBar ? Text("Hide Sidebar"): Text("Show Sidebar")
                
            }, icon: {
                Image(systemName: "sidebar.right")
            })
        })
        .help(showSideBar ? Text("Hide output selection."): Text("Display output selection"))
    }
}
