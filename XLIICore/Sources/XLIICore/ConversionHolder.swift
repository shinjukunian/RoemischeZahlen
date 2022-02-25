//
//  ConversionHolder.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation
import SwiftUI

public class NumeralConversionHolder: Equatable{
    
    public static func == (lhs: NumeralConversionHolder, rhs: NumeralConversionHolder) -> Bool {
        lhs.input == rhs.input && lhs.output == rhs.output && lhs.originalText == rhs.originalText
    }
    
    
    public var formattedOutput:String = ""
    
    lazy var localizedSpellOutFormatter: NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .spellOut
        f.formattingContext = .standalone
        return f
    }()
    
    lazy var integerFormatter:NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits=0
        return f
    }()
    
    lazy var formatter=ExotischeZahlenFormatter()
    
    public let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    public let input:Int
    public let output:Output
    let originalText:String
    
    public init(input:Int, output:Output, originalText:String){
        self.input=input
        self.output=output
        self.originalText=originalText
        self.formattedOutput =  parse()
    }
    
    func parse()->String{
        let zahl=input
        let formattedOutput:String
        switch output {
        case .römisch:
            formattedOutput = formatter.macheRömischeZahl(aus: zahl) ?? noValidNumber
        case .japanisch:
            formattedOutput = formatter.macheJapanischeZahl(aus: zahl) ?? noValidNumber
        case .arabisch:
            formattedOutput = integerFormatter.string(from: NSNumber(value: zahl)) ?? noValidNumber
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
            formattedOutput = formatter.machePhoenizischeZahl(aus: zahl) ?? noValidNumber
        }
        return formattedOutput
        
    }
    
    public func speak(){
        formatter.speak(input: SpeechOutput(text: String(input), format: .arabisch), output: SpeechOutput(text: formattedOutput, format: output))
    }
    
    
    @available(iOS 11.0, *)
    public var itemProvider:NSItemProvider{
        let provider=NSItemProvider(item: nil, typeIdentifier: Output.dragType)
        provider.registerObject(self.formattedOutput as NSString, visibility: .all)
        provider.registerItem(forTypeIdentifier: Output.dragType, loadHandler: {handler,object,e in
            guard let handler=handler else{
                return
            }
            handler(self.output.rawValue as NSString, nil)
            
        })
        return provider
    }
    
    
    
}
