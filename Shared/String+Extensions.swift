//
//  String+Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation
import CoreGraphics

extension String{
    var potenzielleRömischeZahl:Bool{
        let romischerBuchstabenHaufen=CharacterSet(charactersIn: "iIvVxXlLcCdDmMD̅L̅V̅X̅")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: romischerBuchstabenHaufen)
    }
    
    var potenzielleJapanischeZahl:Bool{
        let japanischeZahlenBuchstabenHaufen=CharacterSet(charactersIn: "一二三四五六七八九十百千万億壱弐参肆伍陸漆捌玖拾陌阡萬")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: japanischeZahlenBuchstabenHaufen)
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
