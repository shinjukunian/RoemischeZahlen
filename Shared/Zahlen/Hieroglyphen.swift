//
//  Hieroglyphen.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import Foundation

//http://jtotobsc.blogspot.com/2010/11/simplified-egyptian-numerals.html

struct Zehntausender_Hieroglyphen: AlsHieroglyphenZahl{
    
    let anzahl:Int
    let multiplikator:Int = 10_000
    
    let arabischHieroglyphenDict: [Int : String] = [0:"",
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
    
    init(Zahl:Int){
        let hundertTausender = Zahl / 100_000
        let zehntausender = Zahl - 100_000 * hundertTausender
        anzahl = zehntausender / multiplikator
    }
    
}

struct HundertTausender_Hieroglyphen: AlsHieroglyphenZahl{
    
    let anzahl:Int
    let multiplikator:Int = 100_000
    
    let arabischHieroglyphenDict: [Int : String] = [0:"",
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
    
    init(Zahl:Int){
        let millionen = Zahl / 1_000_000
        let hunderttausender = Zahl - 1_000_000 * millionen
        anzahl = hunderttausender / multiplikator
    }
    
}

struct Millionen_Hieroglyphen: AlsHieroglyphenZahl{
    
    let anzahl:Int
    let multiplikator:Int = 10_00_000
    
    let arabischHieroglyphenDict: [Int : String] = [0:"",
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
    
    init(Zahl:Int){
        let zehnMillionen = Zahl / 10_000_000
        let millionen = Zahl - 10_000_000 * zehnMillionen
        anzahl = millionen / multiplikator
    }
    
}
