//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import Foundation

extension CyrillicNumber{
    
    static let titlo=Character(Unicode.Scalar(0x0483)!)
    static let leftTitlo = Character(Unicode.Scalar(0xFE2E)!)
    static let centerTitlo = Character(Unicode.Scalar(0xFE26)!)
    static let rightTitlo = Character(Unicode.Scalar(0xFE2F)!)
    
    static let table = [0:"",
                 1:"А",
                 2:"В",
                 3:"Г",
                 4:"Д",
                 5:"Е",
                 6:"Ѕ",
                 7:"З",
                 8:"И",
                 9:"Ѳ",
                 10:"І",
                 11:"АІ",
                 12:"ВІ",
                 13:"ГІ",
                 14:"ДІ",
                 15:"ЕІ",
                 16:"ЅІ",
                 17:"ЗІ",
                 18:"ИІ",
                 19:"ѲІ",
                 20:"К",
                 30:"Л",
                 40:"М",
                 50:"Н",
                 60:"Ѯ",
                 70:"О",
                 80:"П",
                 90:"Ч",
                 100:"Р",
                 200:"С",
                 300:"Т",
                 400:"У",
                 500:"Ф",
                 600:"Х",
                 700:"Ѱ",
                 800:"Ѿ",
                 900:"Ц",
    ]
    
    
    static let thousandsSymbol = "҂"
    
    static let tenThousandSymbol = String(UnicodeScalar(0x20DD)!)
    static let hundredThousandSymbol = String(UnicodeScalar(0x0488)!)
    static let millionSymbol = String(UnicodeScalar(0x0489)!)
    static let tenMillionSymbol = String(UnicodeScalar(0xA670)!)
    static let hundredMillionSymbol = String(UnicodeScalar(0xA671)!)
    static let billionSymbol = String(UnicodeScalar(0xA672)!)
    
    static var modifierSymbols : Set<UnicodeScalar>{
        let symbols=[CyrillicNumber.tenMillionSymbol.unicodeScalars, CyrillicNumber.tenThousandSymbol.unicodeScalars, CyrillicNumber.millionSymbol.unicodeScalars, CyrillicNumber.hundredMillionSymbol.unicodeScalars, CyrillicNumber.hundredThousandSymbol.unicodeScalars, CyrillicNumber.billionSymbol.unicodeScalars].flatMap({$0})
        return Set(symbols)
    }
    
    static func strippingTitlo(_ string:String)->String{
        let titloSet=Set([CyrillicNumber.titlo, CyrillicNumber.centerTitlo, CyrillicNumber.rightTitlo, CyrillicNumber.leftTitlo].compactMap({$0.unicodeScalars.first}))
        return String(string.unicodeScalars
                        .filter({titloSet.contains($0) == false}))
    }
    
    public static func numericallyEqual(_ lhs:String, _ rhs:String)->Bool{
        return CyrillicNumber.strippingTitlo(lhs).uppercased() == CyrillicNumber.strippingTitlo(rhs).uppercased()
    }
    
    static func canonicalForm(_ string:String)->String{
        return CyrillicNumber.strippingTitlo(string).uppercased()
    }
    
    static func textContainsModifiers(text:String)->Bool{
        let scalarsSet=Set(text.unicodeScalars)
        return scalarsSet.isDisjoint(with: CyrillicNumber.modifierSymbols) == false
    }
    
}



extension Cyrillic{
    var cyrilicUsingTitlo:String{
        guard CyrillicNumber.textContainsModifiers(text: cyrillic) == false else{
            return cyrillic
        }
        var formatted=cyrillic
        let hundredsRangeStart=cyrillic.range(of: CyrillicNumber.thousandsSymbol, options: [.backwards, .caseInsensitive])?.upperBound ?? cyrillic.startIndex
        let subString=cyrillic[hundredsRangeStart..<cyrillic.endIndex]
        var count=subString.count
        if count.isMultiple(of: 2), count > 1{
            count-=1
        }
        let center=count / 2
        let pos = center
        let centerOffset = formatted.index(formatted.endIndex, offsetBy: -pos, limitedBy: formatted.startIndex) ?? formatted.endIndex
        formatted.insert(CyrillicNumber.titlo, at: centerOffset)
        return formatted
    }
}
