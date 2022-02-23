//
//  Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation
import CoreGraphics
import SwiftUI

extension UserDefaults{
    enum Keys {
        static let outPutModesKey = "outPutModesKey"
        static let daijiCompleteKey = "daijiCompleteKey"
        static let allowBasesBesides10Key = "allowBasesBesides10Key"
        static let showSideBarKey = "showSideBarKey"
    }
}


extension NSUserActivity{
    enum ActivityTypes{
        static let conversionActivity = "com.telethon.XLII.conversionActivity"
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

extension CGRect:Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}

extension FocusedValues {
    var conversionItem: Binding<NumeralConversionHolder>? {
        get { self[NumeralConversionHolderKey.self] }
        set { self[NumeralConversionHolderKey.self] = newValue }
    }
    private struct NumeralConversionHolderKey: FocusedValueKey {
        typealias Value = Binding<NumeralConversionHolder>
    }
}
