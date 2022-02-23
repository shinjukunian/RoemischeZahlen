//
//  ConversionInputHolder.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation
import SwiftUI

class ConversionInputHolder:ObservableObject {
    
    struct Payload: Equatable,Codable,Hashable,Identifiable{
        let text:String
        let numeric:Int
        
        var id: String{
            return text
        }
    }
    
    struct NumericParsingResult: Equatable,Hashable,Identifiable{
        var id: String{
            return "\(value)_base\(base)"
        }
        
        let value:Int
        let base:InputType.Base
    }
    
    struct NumericParser{
        let text:String
        let representations:[NumericParsingResult]
        
        init?(text:String, bases:[InputType.Base]){
            self.text=text
            let results=bases.compactMap({base->NumericParsingResult? in
                if let int=Int(text, radix: base.rawValue){
                    return NumericParsingResult(value: int, base: base)
                }
                else{
                    return nil
                }
            })
            guard results.isEmpty == false else{
                return nil
            }
            representations=results
        }

    }
    
    enum InputType: Equatable,Hashable{
        case arabic
        case numeric(results:[NumericParsingResult])
        case textual(output:Output)
        case invalid
        case empty
        case overflow
        
        enum Base:Int, CaseIterable, Equatable, RawRepresentable, Identifiable{
            var id: Self{
                return self
            }
            
            case binary = 2
            case octal = 8
            case decimal = 10
            case hexadecimal = 16
            
            static var allCases: [ConversionInputHolder.InputType.Base] = [.binary, .octal, .decimal, .hexadecimal]
        }
        
    }
    
    @Published var input:String = ""{
        didSet{
            parse()
        }
    }
    
    @Published var numericInput:Int? = nil
    
    @Published var inputType = InputType.empty
    
    @AppStorage(UserDefaults.Keys.outPutModesKey) var outputPreference = OutputPreference(outputs: [.römisch, .japanisch, .suzhou, .hieroglyph, .babylonian])
    
    @AppStorage(UserDefaults.Keys.allowBasesBesides10Key) var otherBases:Bool = true
    
    @Published var outputs:[Output] = [.japanisch,.römisch]{
        didSet{
            outputPreference=OutputPreference(outputs: outputs)
        }
    }
    
    lazy var integerFormatter:NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits=0
        return f
    }()
    
    var preferredBase: InputType.Base = .decimal
    
    init(){
        self.outputs = outputPreference.outputs
    }
    
    let formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    func parse(){
        guard input.isEmpty == false else{
            self.inputType = .empty
            self.numericInput=nil
            return
        }
        
        if otherBases == true,
           let parser=NumericParser(text: input, bases: InputType.Base.allCases),
            parser.representations.isEmpty == false,
            let first=(parser.representations.first(where: {$0.base == preferredBase}) ?? parser.representations.first){
                numericInput=first.value
            self.inputType = .numeric(results: parser.representations)
        }
        else if let zahl = Int(input){
            numericInput=zahl
            self.inputType = .arabic
            
        }
        else if let arabisch = formatter.macheZahl(aus: input),
                let output=Output(output: arabisch){
            numericInput=arabisch.value
            self.inputType = .textual(output: output)
        }
        else if let arabisch = integerFormatter.number(from: input){
            if arabisch.compare(NSNumber(value: Double(Int.max))) == .orderedAscending{
                numericInput=arabisch.intValue
                self.inputType = .textual(output: .arabisch)
            }
            else{
                self.inputType = .overflow
            }
            
        }
        else{
            numericInput=nil
            self.inputType = .invalid
        }
        
    }
    
    
    
}
