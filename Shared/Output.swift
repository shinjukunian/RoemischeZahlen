//
//  Output.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation

enum Output: Identifiable, Codable, Equatable, RawRepresentable, Hashable, CustomStringConvertible{
    
    typealias RawValue = String
    
    case römisch
    case japanisch
    case arabisch
    case japanisch_bank
    case babylonian
    case aegean
    case sangi
    case hieroglyph
    case suzhou
    case phoenician
    
    case numeric(base:Int)
    
    case localized(locale:Locale)
    
    static let currentLocale = Output.localized(locale: Locale.current)
    static let dragType = "com.mihomaus.xlii.outputType"

    static let numericTypes:[Output] = [.numeric(base: 2), .numeric(base: 8), .numeric(base: 16)]
    static let builtin:[Output] = [.römisch, .japanisch, .japanisch_bank, .suzhou, .babylonian, .aegean, .sangi, .hieroglyph, .phoenician]
    
    init?(rawValue: String) {
        switch rawValue{
        case "roman":
            self = .römisch
        case "japanese":
            self = .japanisch
        case "arabic":
            self = .arabisch
        case "japanese_banking":
            self = .japanisch_bank
        case "babylonian":
            self = .babylonian
        case "aegean":
            self = .aegean
        case "sangi":
            self = .sangi
        case "hieroglyph":
            self = .hieroglyph
        case "suzhou":
            self = .suzhou
        case "phoenician":
            self = .phoenician
        case _ where rawValue.hasPrefix("numeric_base"):
            let components=rawValue.split(separator: "|")
            guard components.count == 2,
                  let base=Int(components[1])
            else {return nil}
            
            self = .numeric(base: base)
        case _ where rawValue.hasPrefix("localized"):
            let components=rawValue.split(separator: "|")
            guard components.count == 2
            else {return nil}
            let locale=Locale(identifier: String(components[1]))
            self = .localized(locale: locale)
        default:
            return nil
        }
    }
    
    init?(output:ExotischeZahlenFormatter.NumericalOutput){
        switch output.locale{
        case .japanese:
            self = .japanisch
        case .roman:
            self = .römisch
        case .suzhou:
            self = .suzhou
        case .hieroglyph:
            self = .hieroglyph
        case .aegean:
            self = .aegean
        case .phoenician:
            self = .phoenician
        }
    }
    
    var rawValue: String{
        switch self {
        case .römisch:
            return "roman"
        case .japanisch:
            return "japanese"
        case .arabisch:
            return "arabic"
        case .japanisch_bank:
            return "japanese_banking"
        case .babylonian:
            return "babylonian"
        case .localized(let locale):
            return "localized|\(locale.identifier)"
        case .aegean:
            return "aegean"
        case .sangi:
            return "sangi"
        case .hieroglyph:
            return "hieroglyph"
        case .suzhou:
            return "suzhou"
        case .phoenician:
            return "phoenician"
        case .numeric(let base):
            return "numeric_base|\(base)"
        }
    }
    
    
    var id: String {
        return rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .römisch, .japanisch, .japanisch_bank, .arabisch, .babylonian, .aegean, .sangi, .hieroglyph, .suzhou, .phoenician:
            hasher.combine(rawValue)
        case .localized(_), .numeric(_):
            hasher.combine(rawValue)
        }
    }
    
    var description: String{
        switch self {
        case .römisch:
            return NSLocalizedString("Roman", comment: "Roman Numeral Output")
        case .japanisch:
            return NSLocalizedString("Japanese", comment: "Japanese Numeral Output")
        case .arabisch:
            return NSLocalizedString("Arabic Numerals", comment: "Arabic Numeral Output")
        case .japanisch_bank:
            return NSLocalizedString("Japanese (大字)", comment: "Arabic Numeral Output")
        case .babylonian:
            return NSLocalizedString("Babylonian Cuneiform", comment: "Arabic Numeral Output")
        case .aegean:
            return NSLocalizedString("Aegean", comment: "Aegean Output")
        case .sangi:
            return NSLocalizedString("Counting Rods (籌)", comment: "Aegean Output")
        case .hieroglyph:
            return NSLocalizedString("Egyptian Numerals (Hieroglyphs)", comment: "Egytpian Output")
        case .suzhou:
            return NSLocalizedString("Suzhou (蘇州碼子)", comment: "Suzhou Output")
        case .phoenician:
            return NSLocalizedString("Phoenician", comment: "Phoenician alphabetPhoenician")
        case .localized(let locale):
            if let language=locale.languageCode{
                return Locale.current.localizedString(forLanguageCode: language) ?? locale.identifier
            }
            else{
                return Locale.current.localizedString(forIdentifier: locale.identifier) ?? locale.identifier
            }
        case .numeric(let base):
            switch base{
            case 2:
                return NSLocalizedString("Binary", comment: "binary number")
            case 8:
                return NSLocalizedString("Octal", comment: "Octal number")
            case 10:
                return NSLocalizedString("Decimal", comment: "decimal number")
            case 16:
                return NSLocalizedString("Hexadecimal", comment: "Hexadecimal number")
            default:
                return String(format: NSLocalizedString("Numeric Base %i", comment: "Other base"), base)
            }
        }
    }
    
    
    
}


struct OutputPreference:RawRepresentable{
    
    typealias RawValue = String
    
    let outputs:[Output]
    
    init?(rawValue: String) {
        let values=rawValue.split(separator: "%").compactMap({Output(rawValue: String($0))})
        self.outputs=values
    }
    
    init(outputs:[Output]){
        self.outputs=outputs
    }
    
    var rawValue: String{
        return self.outputs.map({$0.rawValue}).joined(separator: "%")
    }
}
