//
//  ConversionInputHolder.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation
import SwiftUI
import XLIICore

class ConversionInputHolder:ObservableObject {
    
    struct Payload: Equatable,Codable,Hashable,Identifiable{
        let text:String
        let numeric:Int
        
        var id: String{
            return text
        }
    }

    @Published var input:String = ""{
        didSet{
            parse()
        }
    }
    
    
    @Published var results:[NumericParsingResult] = [.empty]
    @Published var state:InputType = .empty
    
    @Published var selectedResult:NumericParsingResult = .empty
    
    @AppStorage(UserDefaults.Keys.outPutModesKey) var outputPreference: OutputPreference = .default
    
    @AppStorage(UserDefaults.Keys.allowBasesBesides10Key) var otherBases:Bool = true

    @AppStorage(UserDefaults.Keys.preferredBasesKey) var preferredBases:BasePreference = BasePreference.default

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
    
    
    
    init(){
        self.outputs = outputPreference.outputs
    }
    
    let formatter=ExotischeZahlenFormatter()
    
    let noValidNumber=NSLocalizedString("Conversion not possible.", comment: "")
    let noInput = NSLocalizedString("No Input", comment: "")
    
    func parse(){
        let input=self.input.trimmingCharacters(in: .whitespaces)
        guard input.isEmpty == false else{
            self.results.removeAll()
            self.state = .empty
            return
        }
        
        var results=[NumericParsingResult]()
        
        if otherBases == true,
           let parser=NumericParser(text: input, bases: preferredBases.bases),
            parser.representations.isEmpty == false{
            results.append(contentsOf: parser.representations)
        }
        else{
            if let zahl = Int(input){
                results.append(NumericParsingResult(originalText: self.input, value: zahl, type: .arabisch))
            }
            else if let arabisch = integerFormatter.number(from: input){
                if arabisch.compare(NSNumber(value: Double(Int.max))) == .orderedAscending{
                    results.append(NumericParsingResult(originalText: self.input, value: arabisch.intValue, type: .arabisch))
                }
                else{
                    self.state = .overflow
                }
                
            }
        }
        if let arabisch = formatter.macheZahl(aus: input),
                let output=Output(output: arabisch){
            results.append(NumericParsingResult(originalText: self.noInput, value: arabisch.value, type: output))
            
        }
        
        
        guard results.isEmpty == false else{
                self.results.removeAll()
                self.state = .invalid
            return
        }
        
        self.results=results
        self.state = .valid
    }
}
