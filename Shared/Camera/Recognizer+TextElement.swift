//
//  Recognizer+TextElement.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/05.
//

import Foundation
import XLIICore
import CoreGraphics

extension Recognizer{
    struct TextElement: Equatable, Identifiable{
       
        enum TextElementType:Equatable {
            case arabicNumber(number:Int)
            case romanNumeral(number:Int)
            case japaneseNumber(number:Int)
            case other
            
            init(text:String) {
                if let number=ExotischeZahlenFormatter().macheZahl(aus: text){
                    switch number.locale{
                    case .roman:
                        self = .romanNumeral(number: number.value)
                    case .japanese:
                        self = .japaneseNumber(number: number.value)
                    default:
                        self = .other
                    }
                }
                else if let number=NumberFormatter().number(from: text)?.intValue{
                    self = .arabicNumber(number: number)
                }
                else{
                    self = .other
                }
            }
            
            var isNumber:Bool{
                return self != .other
            }
        }
        
        typealias ID = CGRect
        
        let rect:CGRect
        let text:String
        let type: TextElementType
        let formatter=ExotischeZahlenFormatter()
        
        var id: CGRect{
            return self.rect
        }
    
        init(text:String, rect:CGRect) {
            self.text=text
            self.rect=rect
            self.type = TextElementType(text: text)
        }
        
        
        
        static func == (lhs: Recognizer.TextElement, rhs: Recognizer.TextElement) -> Bool {
            return lhs.rect == rhs.rect
        }
        
        
        func convert(output:Output)->String?{
            
            switch type {
            case .arabicNumber(let number), .romanNumeral(let number), .japaneseNumber(let number):
                switch output {
                case .römisch:
                    return formatter.macheRömischeZahl(aus: number)
                case .japanisch:
                    return formatter.macheJapanischeZahl(aus: number)
                case .arabisch:
                    return String(number)
                case .japanisch_bank:
                    return formatter.macheJapanischeBankZahl(aus: number, einfach: true)
                case .babylonian:
                    return formatter.macheBabylonischeZahl(aus: number)
                case .aegean:
                    return formatter.macheAegaeischeZahl(aus: number)
                case .sangi:
                    return formatter.macheSangiZahl(aus: number)
                case .hieroglyph:
                    return formatter.macheHieroglyphenZahl(aus: number)
                case .suzhou:
                    return formatter.macheSuzhouZahl(aus: number)
                case .phoenician:
                    return formatter.machePhoenizischeZahl(aus: number)
                case .numeric(let base):
                    return String(number, radix: base)
                case .kharosthi:
                    return formatter.macheKharosthiZahl(aus: number)
                case .brahmi_traditional:
                    return formatter.macheBrahmiZahl(aus: number, positional: false)
                case .brahmi_positional:
                    return formatter.macheBrahmiZahl(aus: number, positional: true)
                case .glagolitic:
                    return formatter.macheGlagolitischeZahl(aus: number)
                case .cyrillic:
                    let useUppercase=UserDefaults.shared.bool(forKey: UserDefaults.Keys.uppercaseCyrillicKey)
                    return formatter.macheKyrillischeZahl(aus: number, titlo: true, mitKreisen: false, Großbuchstaben: useUppercase)
                case .geez:
                    return formatter.macheGeezZahl(aus: number)
                case .localized(let locale):
                    let f=NumberFormatter()
                    f.numberStyle = .spellOut
                    f.formattingContext = .standalone
                    f.locale=locale
                    return f.string(from: NSNumber(value: number))
                }
            case .other:
                return nil
            }
            
        }
    }
}
