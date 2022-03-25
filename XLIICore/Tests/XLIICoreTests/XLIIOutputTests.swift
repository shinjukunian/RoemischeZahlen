//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/03/25.
//

import Foundation
import XCTest
import XLIICore

class XLIIOutputTests:XCTestCase{
    
    func testAllOutputs(){
        let number=42
        let outputs=Output.builtin
        for output in outputs{
            let holder=NumeralConversionHolder(input: number, output: output, originalText: String(number))
            XCTAssert(holder.formattedOutput.isEmpty == false)
            print("\(holder.input) is \(holder.formattedOutput) as \(holder.output.description)")
        }
        
        let number2=2022
        var options=NumeralConversionHolder.ConversionContext()
        options.uppercaseCyrillic=false
        var holder=NumeralConversionHolder(input: number2, output: .cyrillic, originalText: String(number2), context: options)
        print("\(holder.input) is \(holder.formattedOutput) as \(holder.output.description)")
        options.uppercaseCyrillic=true
        holder=NumeralConversionHolder(input: number2, output: .cyrillic, originalText: String(number2), context: options)
        print("\(holder.input) is \(holder.formattedOutput) as \(holder.output.description)")
    }
    
    func testInputs() throws {
        let excluded=Set([Output.babylonian])
        let outputs=Output.builtin.filter({excluded.contains($0) == false})
        
        let number=42
        let formatter=ExotischeZahlenFormatter()
        for output in outputs{
            let holder=NumeralConversionHolder(input: number, output: output, originalText: String(number))
            XCTAssert(holder.formattedOutput.isEmpty == false)
            print("\(holder.input) is \(holder.formattedOutput) as \(holder.output.description)")
            let parsed=try XCTUnwrap(formatter.macheZahl(aus: holder.formattedOutput), "backconversion failed for \(holder.formattedOutput)")
            if output == .japanisch || output == .japanisch_bank{ //these will parse to japanese
                XCTAssert(Output(output: parsed) == .japanisch, "output different for \(parsed.locale) expected \(output.description)")

            }
            else{
                XCTAssert(Output(output: parsed) == output, "output different for \(parsed.locale) expected \(output.description)")

            }
            XCTAssert(parsed.value == number)
            
        }
    }
    
}
