//
//  ConversionDetailHolder.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation
import XLIICore

class ConversionDetailHolder:ObservableObject{
    
    enum State{
        case empty
        case invalid
        case converted
    }
    
    enum Input{
        case decimal
        case textual
    }
    
    
    @Published var textualInput:String = ""{
        didSet{
            guard textualInput.isEmpty == false else{
                self.state = .empty
                return
            }
            switch output{
            case .numeric(let base):
                self.parseNumeric(base: base)
            default:
                self.parseTextual()
            }
            
            
        }
    }
    
    @Published var numericalInput:Int = 0{
        didSet{
            self.textualInput.removeAll()
            let h=NumeralConversionHolder(input: numericalInput, output: output, originalText: "")
            self.state = .converted
            self.formattedNumericOutput=integerFormatter.string(from: NSNumber(integerLiteral: numericalInput)) ?? ""
            self.formattedConvertedOutput=h.formattedOutput
        }
    }
        
    @Published var formattedNumericOutput:String = ""
    @Published var formattedConvertedOutput:String = ""
    @Published var input = Input.textual
    
    let output:Output
    let formater=ExotischeZahlenFormatter()
    let integerFormatter: NumberFormatter = {
        let f=NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits=0
        return f
    }()
    
    @Published var state:State = .empty
    
    init(output:Output){
        self.output=output
    }
    
    init(item:NumeralConversionHolder){
        self.output=item.output
        self.numericalInput=item.input
    }
    
    var outputDescription:String{
        return output.description
    }
    
    func clear(){
        textualInput.removeAll()
        numericalInput=0
        self.state = .empty
    }
    
    func parseNumeric(base:Int){
        guard let result=Int(textualInput, radix:base) else{
            self.state = .invalid
            return
        }
        self.state = .converted
        formattedConvertedOutput = textualInput
        formattedNumericOutput = integerFormatter.string(from: NSNumber(integerLiteral: result)) ?? ""
    }
    
    
    func parseTextual(){
        if let result=formater.macheZahl(aus: textualInput),
           let foundOutput=Output(output: result){
            let backConverted=NumeralConversionHolder(input: result.value, output: output, originalText: "").formattedOutput
            switch output{
            case .cyrillic where output == foundOutput:
                guard CyrillicNumber.numericallyEqual(backConverted, textualInput) else{
                    self.state = .invalid
                    return
                }
            case .japanisch where foundOutput == .japanisch, .japanisch_bank where foundOutput == .japanisch:
                guard backConverted == textualInput else{
                    self.state = .invalid
                    return
                }
            case _ where output == foundOutput:
                guard backConverted == textualInput else{
                    self.state = .invalid
                    return
                }
            default:
                self.state = .invalid
                return
            }
            
            self.state = .converted
            formattedConvertedOutput=textualInput
            formattedNumericOutput=integerFormatter.string(from: NSNumber(integerLiteral: result.value)) ?? ""
        } else{
            self.state = .invalid
        }
    }
}
