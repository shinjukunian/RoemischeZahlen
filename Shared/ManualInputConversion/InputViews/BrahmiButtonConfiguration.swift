//
//  BrahmiButtonConfiguration.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation

struct BrahmiButtonConfiguration:ButtonProvidingInputFormatting{
   
    
    let onesDict = [0:"",
                   1:"𑁒",
                   2:"𑁓",
                   3:"𑁔",
                   4:"𑁕",
                   5:"𑁖",
                   6:"𑁗",
                   7:"𑁘",
                   8:"𑁙",
                   9:"𑁚"
    ]
    
    let tensDict = [0:"",
                    1:"𑁛",
                    2:"𑁜",
                    3:"𑁝",
                    4:"𑁞",
                    5:"𑁟",
                    6:"𑁠",
                    7:"𑁡",
                    8:"𑁢",
                    9:"𑁣"
    ]
    
    let hundertSymbol = "𑁤"
    let thousandSymbol = "𑁥"
    let joiner=String(Unicode.Scalar.init(0x1107F)!)
    
    let tables: [[Int : String]]
    
    let buttonValues: [[String]]
    
    let values: [[Int]]
    var formattingHandler: (String) -> String = {s in return s}
    
    init(){
        self.tables=[onesDict,tensDict]
        self.buttonValues=[["𑁒","𑁓","𑁔","𑁕"],["𑁖","𑁗","𑁘","𑁙"],["𑁚","𑁛","𑁜","𑁝"],["𑁞","𑁟","𑁠","𑁡"],["𑁢","𑁣","𑁤","𑁥"]].reversed()
        self.values = [[1,2,3,4,],[5,6,7,8],[9,10,20,30],[40,50,60,70],[80,90,100,1000]].reversed()
        self.formattingHandler = parseInput(_:)
    }
    
    func parseInput(_ string:String)->String{
        let suffix=string.suffix(2)
        guard suffix.count == 2,
                let appended=suffix.last,
                let present=suffix.first,
                [hundertSymbol,thousandSymbol].contains(String(present))
        else{
            return string
        }
        let endIDX=string.index(string.endIndex, offsetBy: -2)
        let subString=string[string.startIndex..<endIDX]
        let new=String(subString) + String(present) + joiner + String(appended)
        return new
    }
}
