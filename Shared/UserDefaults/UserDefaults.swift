//
//  UserDefaults.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/25.
//

import Foundation

extension UserDefaults{
    enum Keys {
        static let outPutModesKey = "outPutModesKey"
        static let daijiCompleteKey = "daijiCompleteKey"
        static let allowBasesBesides10Key = "allowBasesBesides10Key"
        static let showSideBarKey = "showSideBarKey"
        static let preferredBasesKey = "preferredBases"
        static let historyPreferenceKey = "historyPreferenceKey"
    }
    
    static var shared:UserDefaults{
        #if os(macOS)
        UserDefaults(suiteName: ".group.telethon.XLII")!
        #else
        UserDefaults(suiteName: "DVQ96RL@KL.group.telethon.XLII")!
        #endif
    }
}
