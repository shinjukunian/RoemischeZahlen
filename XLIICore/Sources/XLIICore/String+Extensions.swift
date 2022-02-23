//
//  String+Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation

extension String{
    var potenzielleRömischeZahl:Bool{
        let romischerBuchstabenHaufen=CharacterSet(charactersIn: "iIvVxXlLcCdDmMD̅L̅V̅X̅")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: romischerBuchstabenHaufen)
    }
    
    var potenzielleJapanischeZahl:Bool{
        let japanischeZahlenBuchstabenHaufen=CharacterSet(charactersIn: "一二三四五六七八九十百千万億壱弐参肆伍陸漆捌玖拾陌阡萬兆")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: japanischeZahlenBuchstabenHaufen)
    }
    
    var potenzielleSuzhouZahl:Bool{
        let suzhou=CharacterSet(charactersIn: "〇〡〢〣〤〥〦〧〨〩一二三")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: suzhou)
    }
    
    var potenzielleHieroglypheZahl:Bool{
        let start=Unicode.Scalar.init(0x13000)!
        let end=Unicode.Scalar(0x1342F)!
        let hieroglyphs=CharacterSet(charactersIn: start...end)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: hieroglyphs)
    }
    
    var potenziellAegaeischeZahl:Bool{
        let start=Unicode.Scalar.init(0x10100)!
        let end=Unicode.Scalar(0x10133)!
        let aegean=CharacterSet(charactersIn: start...end)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: aegean)
    }
    
    var potentiellePhoenizischeZahl:Bool{
        let start=Unicode.Scalar.init(0x10900)!
        let end=Unicode.Scalar(0x1091B)!
        let phoenician=CharacterSet(charactersIn: start...end)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: phoenician)
    }
}

