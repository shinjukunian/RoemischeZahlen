//
//  ConversionHolder.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation
import SwiftUI

class NumeralConversionHolder{
    
    struct ConversionInfo:Equatable,Codable{
        let input:Int
        let outputMode:Output
    }
    
    
    var formattedOutput:String = ""
    
    lazy var localizedSpellOutFormatter: NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .spellOut
        f.formattingContext = .standalone
        return f
    }()
    
    lazy var formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    
    let info:ConversionInfo
    
    init(info:ConversionInfo){
        self.info=info
        parse()
    }
    
    func parse(){
        let zahl=info.input
        switch info.outputMode {
        case .römisch:
            formattedOutput = formatter.macheRömischeZahl(aus: zahl) ?? noValidNumber
        case .japanisch:
            formattedOutput = formatter.macheJapanischeZahl(aus: zahl) ?? noValidNumber
        case .arabisch:
            formattedOutput = String(zahl)
        case .japanisch_bank:
            formattedOutput = formatter.macheJapanischeBankZahl(aus: zahl, einfach: true) ?? noValidNumber
        case .babylonian:
            formattedOutput = formatter.macheBabylonischeZahl(aus: zahl) ?? noValidNumber
        case .aegean:
            formattedOutput = formatter.macheAegaeischeZahl(aus: zahl) ?? noValidNumber
        case .sangi:
            formattedOutput = formatter.macheSangiZahl(aus: zahl) ?? noValidNumber
        case .hieroglyph:
            formattedOutput = formatter.macheHieroglyphenZahl(aus: zahl) ?? noValidNumber
        case .suzhou:
            formattedOutput = formatter.macheSuzhouZahl(aus: zahl) ?? noValidNumber
        case .localized(let locale):
            localizedSpellOutFormatter.locale=locale
            formattedOutput = localizedSpellOutFormatter.string(from: NSNumber(value: zahl)) ?? noValidNumber
        case .numeric(let base):
            formattedOutput = String(zahl, radix: base, uppercase: true)
        case .phoenician:
            formattedOutput = PhoenizianFormatter(number: zahl)?.phoenician ?? noValidNumber
        }
        
    }
    
    func speak(){
        formatter.speak(input: SpeechOutput(text: String(info.input), format: .arabisch), output: SpeechOutput(text: formattedOutput, format: info.outputMode))
    }
    
    
    
    
}
