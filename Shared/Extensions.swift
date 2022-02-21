//
//  Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation

extension UserDefaults{
    enum Keys {
        static let outPutModesKey = "outPutModesKey"
        static let daijiCompleteKey = "daijiCompleteKey"
        static let allowBasesBesides10Key = "allowBasesBesides10Key"
    }
}


extension NSUserActivity{
    enum ActivityTypes{
        static let conversionActivity = "com.mihomaus.RoemischeZahl.conversionActivity"
    }
}

public extension Bundle{
    var applicationName:String{
        return (self.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }
    var version:String{
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    var build:String{
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
}
