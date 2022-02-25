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

extension URL{
    static let widgetScheme:String = "XLIIdeepLink"
    static let numberItemName:String = "XLII_deepLink_number"
    
    static func deeplinkURL(number:Int)->URL{
        var urlComponents=URLComponents()
        urlComponents.scheme=URL.widgetScheme
        urlComponents.host="com.telethon.XLII"
        let item=URLQueryItem(name: URL.numberItemName, value: String(number))
        urlComponents.queryItems=[item]
        return urlComponents.url ?? URL(string: "")!
    }
    
    var numberFromDeepLink:Int?{
        guard let components=URLComponents(url: self, resolvingAgainstBaseURL: true),
                components.scheme == URL.widgetScheme,
              let item=components.queryItems?.first(where: {$0.name == URL.numberItemName}),
              let value=item.value
        else{
            return nil
        }
        return Int(value)
    }
}
