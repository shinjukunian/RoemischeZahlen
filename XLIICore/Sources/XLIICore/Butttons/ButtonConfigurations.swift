//
//  HieroglyphButtonConfiguration.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation

protocol ButtonProvidingInputFormatting: ButtonProviding{
    var tables:[[Int:String]] {get}
    func parseInput(_ string:String)->String
}

extension ButtonProvidingInputFormatting{
    func parseInput(_ string:String)->String{
        let suffix=string.suffix(2)
        guard suffix.count == 2,
                let appended=suffix.last,
                let present=suffix.first
        else{
            return string
        }
        guard let table=tables.first(where: {$0[1] ?? "" == String(appended)}),
              let presentValue=table.first(where: {v,s in
                  s == String(present)
              })?.key,
                presentValue < 9,
              let newValue=table[presentValue+1]
        else{
             return string
        }
        let retVal=string.filter({suffix.contains($0) == false}) + newValue
        
        
        return retVal
    }
}


struct HieroglyphButtonConfiguration:ButtonProvidingInputFormatting{
    let ones : [Int : String] = [0:"",
                                                    1:"𓏺",
                                                    2:"𓏻",
                                                    3:"𓏼",
                                                    4:"𓏽",
                                                    5:"𓏾",
                                                    6:"𓏿",
                                                    7:"𓐀",
                                                    8:"𓐁",
                                                    9:"𓐂"
    ]
    
    let thousands: [Int : String] = [0:"",
                                                    1:"𓆼",
                                                    2:"𓆽",
                                                    3:"𓆾",
                                                    4:"𓆿",
                                                    5:"𓇀",
                                                    6:"𓇁",
                                                    7:"𓇂",
                                                    8:"𓇃",
                                                    9:"𓇄"
    ]
    
    let tens: [Int : String] = [0:"",
                                                    1:"𓎆",
                                                    2:"𓎇",
                                                    3:"𓎈",
                                                    4:"𓎉",
                                                    5:"𓎊",
                                                    6:"𓎋",
                                                    7:"𓎌",
                                                    8:"𓎍",
                                                    9:"𓎎"
    ]
    
    let hundreds: [Int : String] = [0:"",
                                                    1:"𓍢",
                                                    2:"𓍣",
                                                    3:"𓍤",
                                                    4:"𓍥",
                                                    5:"𓍦",
                                                    6:"𓍧",
                                                    7:"𓍨",
                                                    8:"𓍩",
                                                    9:"𓍪"
    ]
    let tenThousands: [Int : String] = [0:"",
                                                    1:"𓂭",
                                                    2:"𓂮",
                                                    3:"𓂯",
                                                    4:"𓂰",
                                                    5:"𓂱",
                                                    6:"𓂲",
                                                    7:"𓂳",
                                                    8:"𓂴",
                                                    9:"𓂵"
    ]
    
    let hundredThousands: [Int : String] = [0:"",
                                                    1:"𓆐",
                                                    2:"𓆐𓆐",
                                                    3:"𓆐𓆐𓆐",
                                                    4:"𓆐𓆐𓆐𓆐",
                                                    5:"𓆐𓆐𓆐𓆐𓆐",
                                                    6:"𓆐𓆐𓆐𓆐𓆐𓆐",
                                                    7:"𓆐𓆐𓆐𓆐𓆐𓆐𓆐",
                                                    8:"𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐",
                                                    9:"𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐𓆐"
    ]
    
    let millions: [Int : String] = [0:"",
                                                    1:"𓁨",
                                                    2:"𓁨𓁨",
                                                    3:"𓁨𓁨𓁨",
                                                    4:"𓁨𓁨𓁨𓁨",
                                                    5:"𓁨𓁨𓁨𓁨𓁨",
                                                    6:"𓁨𓁨𓁨𓁨𓁨𓁨",
                                                    7:"𓁨𓁨𓁨𓁨𓁨𓁨𓁨",
                                                    8:"𓁨𓁨𓁨𓁨𓁨𓁨𓁨𓁨",
                                                    9:"𓁨𓁨𓁨𓁨𓁨𓁨𓁨𓁨𓁨"
    ]
    
    let buttonValues:[[String]]
    let values:[[Int]]
    
    var formattingHandler: (String) -> String = {s in return s}
    
    let tables:[[Int:String]]
    
    init(){
        self.buttonValues=[[millions[1]!],[thousands[1]!,tenThousands[1]!,hundredThousands[1]!],[ones[1]!,tens[1]!,hundreds[1]!]]
        self.values=[[1_000_000],[1000,10_000,100_000],[1,10,100]]
        self.tables = [ones,tens,hundreds,thousands,tenThousands,hundredThousands,millions]
        self.formattingHandler = parseInput(_:)
    }
}


struct AegeanButtonConfiguration:ButtonProvidingInputFormatting{
    
    let ones: [Int : String] = [0:"",
                                              1:"𐄇",
                                              2:"𐄈",
                                              3:"𐄉",
                                              4:"𐄊",
                                              5:"𐄋",
                                              6:"𐄌",
                                              7:"𐄍",
                                              8:"𐄎",
                                              9:"𐄏"
    ]
    
    let tens: [Int : String] = [0:"",
                                              1:"𐄐",
                                              2:"𐄑",
                                              3:"𐄒",
                                              4:"𐄓",
                                              5:"𐄔",
                                              6:"𐄕",
                                              7:"𐄖",
                                              8:"𐄗",
                                              9:"𐄘"
    ]
    
    let hundreds: [Int : String] = [0:"",
                                              1:"𐄙",
                                              2:"𐄚",
                                              3:"𐄛",
                                              4:"𐄜",
                                              5:"𐄝",
                                              6:"𐄞",
                                              7:"𐄟",
                                              8:"𐄠",
                                              9:"𐄡"
    ]
    
    let thousands: [Int : String] = [0:"",
                                              1:"𐄢",
                                              2:"𐄣",
                                              3:"𐄤",
                                              4:"𐄥",
                                              5:"𐄦",
                                              6:"𐄧",
                                              7:"𐄨",
                                              8:"𐄩",
                                              9:"𐄪"
    ]
    
    let tenThousands: [Int : String] = [0:"",
                                              1:"𐄫",
                                              2:"𐄬",
                                              3:"𐄭",
                                              4:"𐄮",
                                              5:"𐄯",
                                              6:"𐄰",
                                              7:"𐄱",
                                              8:"𐄲",
                                              9:"𐄳"
    ]
    
    let buttonValues:[[String]]
    let values:[[Int]]
    
    var formattingHandler: (String) -> String = {s in return s}
    
    let tables:[[Int:String]]
    
    init(){
        self.buttonValues=[[tenThousands[1]!], [hundreds[1]!,thousands[1]!], [ones[1]!,tens[1]!]]
        self.values=[[10_000],[100,1000],[1,10]]
        self.tables = [ones,tens,hundreds,thousands,tenThousands]
        self.formattingHandler = parseInput(_:)
    }
}
