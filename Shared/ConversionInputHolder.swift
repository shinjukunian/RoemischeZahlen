//
//  ConversionInputHolder.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation
import SwiftUI

class ConversionInputHolder:ObservableObject {
    
    enum InputType: Equatable,Hashable{
        case arabic
        case textual(output:Output)
        case invalid
        case empty
    }
    
    @Published var input:String = ""{
        didSet{
            parse()
        }
    }
    
    @Published var numericInput:Int? = nil
    
    @Published var inputType = InputType.empty
    
    @AppStorage(UserDefaults.Keys.outPutModesKey) var outputPreference = OutputPreference(outputs: [.currentLoale, .römisch, .japanisch, .suzhou, .hieroglyph, .babylonian])
    
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
        guard input.isEmpty == false else{
            self.inputType = .empty
            self.numericInput=nil
            return
        }
        
        if let zahl = Int(input){
            numericInput=zahl
            self.inputType = .arabic
            
        }
        else if let arabisch = formatter.macheZahl(aus: input), let output=Output(output: arabisch){
            numericInput=arabisch.value
            self.inputType = .textual(output: output)
        }
        else if let arabisch = integerFormatter.number(from: input){
            numericInput=arabisch.intValue
            self.inputType = .textual(output: .arabisch)
        }
        else{
            numericInput=nil
            self.inputType = .invalid
        }
        
    }
    
    
    
}
