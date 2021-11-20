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
    
    @Published var numericInput:Int? = nil{
        didSet{
            guard let numericInput = numericInput else{formattedNumericInput = nil; return}
            formattedNumericInput = spellOutFormatter.string(from: NSNumber.init(value: numericInput))
        }
    }
    
    @Published var formattedNumericInput:String?
    
    @Published var formattedOutout:String
    @Published var output:String
    
    
    @AppStorage(UserDefaults.Keys.daijiCompleteKey) var daijiComplete = false

    @Published var outputMode:Output = Output(rawValue: UserDefaults().string(forKey: UserDefaults.Keys.outPutModeKey) ?? "") ?? .römisch{
        didSet{
            parse()
        }
    }
    
    @Published var isValid:Bool = false
    
    lazy var integerFormatter:NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits=0
        return f
    }()
    
    lazy var spellOutFormatter: NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .spellOut
        f.formattingContext = .standalone
        return f
    }()
    
    let formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    
    init() {
        self.formattedOutout = noInput
        self.output = noInput
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
            formattedOutout = NSLocalizedString("No Input", comment: "")
            self.isValid=false
            self.numericInput=nil
            return
        }
        
        if let zahl = Int(input){
            switch outputMode {
            case .römisch:
                formattedOutout = formatter.macheRömischeZahl(aus: zahl) ?? noValidNumber
                output = formattedOutout
            case .japanisch:
                formattedOutout = formatter.macheJapanischeZahl(aus: zahl) ?? noValidNumber
                output = formattedOutout
            case .arabisch:
                formattedOutout = input
                output = formattedOutout
            case .japanisch_bank:
                formattedOutout = formatter.macheJapanischeBankZahl(aus: zahl, einfach: !daijiComplete) ?? noValidNumber
                output = formattedOutout
            }
            numericInput=zahl
            
        }
        else if let arabisch = formatter.macheZahl(aus: input){
            
            formattedOutout = integerFormatter.string(from: NSNumber(integerLiteral: arabisch)) ?? noValidNumber
            output = String(arabisch)
            numericInput=arabisch
        }
        else{
            numericInput=nil
            formattedOutout = noValidNumber
        }
        self.isValid = formattedOutout != noValidNumber
    }
    
    func speak(){
        formatter.speak(input: SpeechOutput(text: input), output: SpeechOutput(text: output))
    }
    
    
    
    
}
