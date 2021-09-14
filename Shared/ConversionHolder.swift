//
//  ConversionHolder.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation
import SwiftUI

enum Output: String, CaseIterable, Identifiable,Codable{
    case römisch
    case japanisch
    case arabisch
    case japanisch_bank
    var id: String { self.rawValue }
}


class NumeralConversionHolder:ObservableObject{
    
    struct ConversionInfo:Equatable,Codable{
        let input:String
        let outputMode:Output
    }
    
    
    @Published var input:String = ""{
        didSet{
            parse()
        }
    }
    
    @Published var output:String
    
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiComplete = false

    @Published var outputMode:Output = Output(rawValue: UserDefaults().string(forKey: UserDefaults.Keys.outPutModeKey) ?? "") ?? .römisch{
        didSet{
            parse()
        }
    }
    
    @Published var isValid:Bool = false
    
    let formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    
    init() {
        self.output=noInput
    }
    
    
    var info:ConversionInfo{
        get{
            return ConversionInfo(input: input, outputMode: outputMode)
        }
        set{
            self.input=newValue.input
            self.outputMode=info.outputMode
        }
        
    }
    
    func parse(){
        guard input.isEmpty == false else{
            output = NSLocalizedString("No Input", comment: "")
            self.isValid=false
            return
        }
        
        if let zahl = Int(input){
            switch outputMode {
            case .römisch:
                output = formatter.macheRömischeZahl(aus: zahl) ?? noValidNumber
            case .japanisch:
                output = formatter.macheJapanischeZahl(aus: zahl) ?? noValidNumber
            case .arabisch:
                output = input
            case .japanisch_bank:
                output = formatter.macheJapanischeBankZahl(aus: zahl, einfach: !daijiComplete) ?? noValidNumber
            }
            
            
        }
        else if let arabisch = formatter.macheZahl(aus: input){
            let f=NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits=0
            output = f.string(from: NSNumber(integerLiteral: arabisch)) ?? noValidNumber
        }
        else{
            output = noValidNumber
        }
        self.isValid = output != noValidNumber
    }
    
    func speak(){
        formatter.speak(input: SpeechOutput(text: input), output: SpeechOutput(text: output))
    }
    
    
    
    
}
