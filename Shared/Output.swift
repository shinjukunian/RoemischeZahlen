//
//  Output.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation

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

enum Output: Identifiable, Codable, Equatable, RawRepresentable, Hashable, CustomStringConvertible{
    
    typealias RawValue = String
    
    case römisch
    case japanisch
    case arabisch
    case japanisch_bank
    case babylonian
    case aegean
    case sangi
    
    case localized(locale:Locale)
    
    static let currentLoale = Output.localized(locale: Locale.current)
    
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
        default:
            let components=rawValue.split(separator: "|")
            guard rawValue.hasPrefix("localized") ,
                  components.count == 2
            else {return nil}
            let locale=Locale(identifier: String(components[1]))
            self = .localized(locale: locale)
        }
    }
    
    init?(output:ExotischeZahlenFormatter.NumericalOutput){
        switch output.locale{
        case .japanese:
            self = .japanisch
        case .roman:
            self = .römisch
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
        }
    }
    
    
    var id: String {
        return rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .römisch, .japanisch, .japanisch_bank, .arabisch, .babylonian, .aegean, .sangi:
            hasher.combine(rawValue)
        case .localized(_):
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
        case .localized(let locale):
            if let language=locale.languageCode{
                return Locale.current.localizedString(forLanguageCode: language) ?? locale.identifier
            }
            else{
                return Locale.current.localizedString(forIdentifier: locale.identifier) ?? locale.identifier
            }
        }
    }
    
    static let builtin:[Output] = [.römisch, .japanisch, .japanisch_bank, .babylonian, .aegean, .sangi]
    
}
