//
//  Output+Buttons.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation
import XLIICore

protocol ButtonProviding{
    var buttonValues:[[String]] {get}
    var values:[[Int]] {get}
    var formattingHandler:(String)->String {get}
}

extension ButtonProviding{
    var formattingHandler:(String)->String  {
        return {s in return s}
    }
}

extension Output{
    struct ButtonConfiguration: ButtonProviding{
        let buttonValues:[[String]]
        let values:[[Int]]
    }
    
    var buttons:ButtonProviding?{
        switch self {
        case .römisch:
            return ButtonConfiguration(buttonValues: [["M"],["C","D"],["X","L"],["I","V"]], values: [[1000],[100,500],[10,50],[1,5]])
        case .japanisch:
            return ButtonConfiguration(buttonValues: [["万","憶"],["十","百","千"],["七","八","九"],["四","五","六"],["一","二","三"]], values: [[10_000,100_000_000],[10,100,1000],[7,8,9],[4,5,6],[1,2,3]])
        case .arabisch:
            return nil
        case .japanisch_bank:
            return nil
        case .babylonian:
            return nil
        case .aegean:
            return AegeanButtonConfiguration()
        case .sangi:
            return nil
        case .hieroglyph:
            return HieroglyphButtonConfiguration()
        case .suzhou:
            return nil
        case .phoenician:
            return ButtonConfiguration(buttonValues: [["𐤙","𐤘","𐤗"],["𐤖","𐤚","𐤛"].reversed()], values: [[100,20,10],[3,2,1]])
        case .kharosthi:
            return ButtonConfiguration(buttonValues: [["𐩄","𐩅","𐩆","𐩇"],["𐩀","𐩁","𐩂","𐩃"]], values: [[10,20,100,1000],[1,2,3,4]])
        case .brahmi_traditional:
            return nil
        case .brahmi_positional:
            return ButtonConfiguration(buttonValues: [["𑁭","𑁮","𑁯"],["𑁪","𑁫","𑁬"],["𑁧","𑁨","𑁩",],["𑁦"]], values: [[7,8,9],[4,5,6],[1,2,3],[0]])
        case .glagolitic:
            return nil
        case .cyrillic:
            return nil
        case .geez:
            return ButtonConfiguration(buttonValues: [["፸","፹","፺","፻","፼"],["፳","፴","፵","፶","፷"],["፮","፯","፰","፱","፲"],["፩","፪","፫","፬","፭"]], values: [[70,80,90,100,10_000],[20,30,40,50,60],[6,7,8,9,10],[1,2,3,4,5]])
        case .numeric(let base):
            guard base != 10 else{
                return nil
            }
            return NumericButtonConfiguration(base: base)            
        case .localized(_):
            return nil
        }
    }
}

