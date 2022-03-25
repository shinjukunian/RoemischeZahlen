//
//  Output+Buttons.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation

public protocol ButtonProviding{
    var buttonValues:[[String]] {get}
    var values:[[Int]] {get}
    
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    var buttonLabels:[[String]] {get}
    
    var formattingHandler:(String)->String {get}
}


public extension ButtonProviding{
    var formattingHandler:(String)->String  {
        return {s in return s}
    }
    
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    var buttonLabels:[[String]]{
        return self.values.map({$0.map({$0.formatted()})})
    }
}

/// Custom Buttons for Input Keyboards for exotic numbes
extension Output{
    public struct ButtonConfiguration: ButtonProviding{
        public let buttonValues:[[String]]
        public let values:[[Int]]
    }
    
    public var buttons:ButtonProviding?{
        switch self {
        case .römisch:
            return ButtonConfiguration(buttonValues: [["M"],["C","D"],["X","L"],["I","V"]], values: [[1000],[100,500],[10,50],[1,5]])
        case .japanisch:
            return ButtonConfiguration(buttonValues: [["万","億"],["十","百","千"],["七","八","九"],["四","五","六"],["一","二","三"]], values: [[10_000,100_000_000],[10,100,1000],[7,8,9],[4,5,6],[1,2,3]])
        case .arabisch:
            return nil
        case .japanisch_bank:
            return ButtonConfiguration(buttonValues: [["万","億"],["拾","百","千"],["七","八","九"],["四","五","六"],["壱","弐","参"]], values: [[10_000,100_000_000],[10,100,1000],[7,8,9],[4,5,6],[1,2,3]])
        case .babylonian:
            return nil
        case .aegean:
            return AegeanButtonConfiguration()
        case .sangi:
            return ButtonConfiguration(buttonValues: [["𝍯","𝍰","𝍱"],["𝍦","𝍧","𝍨"],["𝍬","𝍭","𝍮"],["𝍣","𝍤","𝍥"],["𝍩","𝍪","𝍫"],["𝍠","𝍡","𝍢"],["〇"]], values: [[7,8,9],[7,8,9],[4,5,6],[4,5,6],[1,2,3],[1,2,3],[0]])
        case .hieroglyph:
            return HieroglyphButtonConfiguration()
        case .suzhou:
            return ButtonConfiguration(buttonValues: [["〧","〨","〩"],["〤","〥","〦"],["一","二","三"],["〡","〢","〣"],["〇"]], values: [[7,8,9],[4,5,6],[1,2,3],[1,2,3],[0]])
        case .phoenician:
            return ButtonConfiguration(buttonValues: [["𐤙","𐤘","𐤗"],["𐤖","𐤚","𐤛"].reversed()], values: [[100,20,10],[3,2,1]])
        case .kharosthi:
            return ButtonConfiguration(buttonValues: [["𐩄","𐩅","𐩆","𐩇"],["𐩀","𐩁","𐩂","𐩃"]], values: [[10,20,100,1000],[1,2,3,4]])
        case .brahmi_traditional:
            return BrahmiButtonConfiguration()
        case .brahmi_positional:
            return ButtonConfiguration(buttonValues: [["𑁭","𑁮","𑁯"],["𑁪","𑁫","𑁬"],["𑁧","𑁨","𑁩",],["𑁦"]], values: [[7,8,9],[4,5,6],[1,2,3],[0]])
        case .glagolitic:
           
            return ButtonConfiguration(buttonValues: [["Ⱍ","Ⱎ","Ⱏ"],["Ⱈ","Ⱉ","Ⱋ","Ⱌ"],["Ⱄ","Ⱅ","Ⱆ","Ⱇ"],["Ⱀ","Ⱁ","Ⱂ","Ⱃ"],["Ⰻ","Ⰼ","Ⰽ","Ⰾ","Ⰿ"],["Ⰵ","Ⰶ","Ⰷ","Ⰸ","Ⰺ"],["Ⰰ","Ⰱ","Ⰲ","Ⰳ","Ⰴ"]], values: [[1000,2000,3000],[600,700,800,900],[200,300,400,500],[70,80,90,100],[20,30,40,50,60],[6,7,8,9,10],[1,2,3,4,5]])
        case .cyrillic:

            return ButtonConfiguration(buttonValues: [["҂"],["Х","Ѱ","Ѿ","Ц"],["С","Т","У","Ф"],["О","П","Ч","Р"],["К","Л","М","Н","Ѯ"],["Ѕ","З","И","Ѳ","І"],["А","В","Г","Д","Е"]], values: [[1000],[600,700,800,900],[200,300,400,500],[70,80,90,100],[20,30,40,50,60],[6,7,8,9,10],[1,2,3,4,5]])
        case .geez:
            return ButtonConfiguration(buttonValues: [["፸","፹","፺","፻","፼"],["፳","፴","፵","፶","፷"],["፮","፯","፰","፱","፲"],["፩","፪","፫","፬","፭"]], values: [[70,80,90,100,10_000],[20,30,40,50,60],[6,7,8,9,10],[1,2,3,4,5]])
        case .sundanese:
            return SundaneseButtonConfiguration()
        case .tibetan:
            return ButtonConfiguration(buttonValues: [["༧","༨","༩"],["༤","༥","༦"],["༡","༢","༣",],["༠"]], values: [[7,8,9],[4,5,6],[1,2,3],[0]])
        case .mongolian:
            return ButtonConfiguration(buttonValues: [["᠗","᠘","᠙"],["᠔","᠕","᠖"],["᠑","᠒","᠓",],["᠐"]], values: [[7,8,9],[4,5,6],[1,2,3],[0]])
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

