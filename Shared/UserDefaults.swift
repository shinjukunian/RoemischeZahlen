//
//  UserDefaults.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation

extension UserDefaults{
    enum Keys {
        static let outPutModesKey = "outPutModesKey"
        static let daijiCompleteKey = "daijiCompleteKey"
    }
}


extension NSUserActivity{
    enum ActivityTypes{
        static let conversionActivity = "com.mihomaus.RoemischeZahl.conversionActivity"
    }
    
    
}
