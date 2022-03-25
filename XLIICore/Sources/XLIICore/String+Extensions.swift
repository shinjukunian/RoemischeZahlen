//
//  String+Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation

///Various helper functions to check whether a number belongs to a certain script.
extension String{
    var potenzielleRömischeZahl:Bool{
        let romischerBuchstabenHaufen=CharacterSet(charactersIn: "iIvVxXlLcCdDmMD̅L̅V̅X̅")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: romischerBuchstabenHaufen)
    }
    
    var potenzielleJapanischeZahl:Bool{
        let japanischeZahlenBuchstabenHaufen=CharacterSet(charactersIn: "一二三四五六七八九十百千万億壱弐参肆伍陸漆捌玖拾陌阡萬兆京")
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
    
    var potentielleKharosthiZahl:Bool{
        let start=Unicode.Scalar.init(0x10A40)!
        let end=Unicode.Scalar(0x10A58)!
        let phoenician=CharacterSet(charactersIn: start...end)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: phoenician)
    }
    
    var potentielleBrahmiZahl:Bool{
        let brahmi=BrahmiNumber.Lookups.traditionalCharacterSet.union(BrahmiNumber.Lookups.positionalCharacterSet)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: brahmi)
    }
    
    var potentielleGlagoliticZahl:Bool{
        let start=Unicode.Scalar.init(0x2c00)!
        let end=Unicode.Scalar(0x2c5f)!
        let gl=CharacterSet(charactersIn: start...end)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: gl)
    }
    
    var potentielleKyrillischeZahl:Bool{
        let startK=UnicodeScalar(0x0400)!
        let endK=UnicodeScalar(0x04FF)!
        let set1=CharacterSet(charactersIn: startK...endK)
        let set2=CharacterSet(charactersIn: UnicodeScalar(0xA460)! ... UnicodeScalar(0xA69F)!)
        var set3=set1.union(set2)
        set3.insert(UnicodeScalar(0x20DD)!)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self).subtracting(.whitespaces)
        return vorhandeneBuchstaben.isSubset(of: set3)
    }
    
    var potentielleGeezZahl:Bool{
        let startK=UnicodeScalar(0x1369)!
        let endK=UnicodeScalar(0x137C)!
        let set=CharacterSet(charactersIn: startK...endK)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self).subtracting(.whitespaces)
        return vorhandeneBuchstaben.isSubset(of: set)
    }
    
    var potentielleSangiZahl:Bool{// something is very wrong with the standard implementation but this works
        let characters="〇𝍠𝍡𝍢𝍣𝍤𝍥𝍦𝍧𝍨𝍩𝍪𝍫𝍬𝍭𝍮𝍯𝍰𝍱"
        let set=Set(characters.map{$0})
        let vorhandeneBuchstaben=Set(self.map({$0})).filter({$0.isWhitespace == false})
        let contained=vorhandeneBuchstaben.isSubset(of: set)
        return contained
    }
    
    var potentielleSundaneseZahl:Bool{
        let characters="᮰᮱᮲᮳᮴᮵᮶᮷᮸᮹|"
        let set=CharacterSet(charactersIn: characters)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self).subtracting(.whitespaces)
        return vorhandeneBuchstaben.isSubset(of: set)
    }
    
    var potentielleTibetanZahl:Bool{
        let characters="༠༡༢༣༤༥༦༧༨༩"
        let set=CharacterSet(charactersIn: characters)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self).subtracting(.whitespaces)
        return vorhandeneBuchstaben.isSubset(of: set)
    }
    
    var potentielleMongolischeZahl:Bool{
        let characters="᠐᠑᠒᠓᠔᠕᠖᠗᠘᠙"
        let set=CharacterSet(charactersIn: characters)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self).subtracting(.whitespaces)
        return vorhandeneBuchstaben.isSubset(of: set)
    }
}

