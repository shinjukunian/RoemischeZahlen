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
        static let uppercaseCyrillicKey = "uppercaseCyrillicKey"
        static let uppercaseNumericLettersKey = "uppercaseNumericLettersKey"
    }
    
    static var shared:UserDefaults{
        #if os(macOS)
        UserDefaults(suiteName: "DVQ96RL2KL.group.telethon.XLII")!
        #else
        UserDefaults(suiteName: "group.telethon.XLII")!
        #endif
    }
    
    var `defaults` : [String:Any]  {
        [UserDefaults.Keys.uppercaseNumericLettersKey : true,
         UserDefaults.Keys.daijiCompleteKey : false,
         UserDefaults.Keys.uppercaseCyrillicKey : false,
         UserDefaults.Keys.allowBasesBesides10Key : true
        ]
    }
    
    func registerDefaults(){
        self.register(defaults: defaults)
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
