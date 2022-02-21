//
//  Hieroglyphen.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import Foundation

//http://jtotobsc.blogspot.com/2010/11/simplified-egyptian-numerals.html


struct Tausender_Hieroglyphen: AlsHieroglyphenZahl{
    let anzahl:Int
    let multiplikator:Int = 1_000
    
    let arabischHieroglyphenDict: [Int : String] = [0:"",
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
    
    init(Zahl:Int){
        let larger = Zahl / 10_000
        let actual = Zahl - 10_000 * larger
        anzahl = actual / multiplikator
    }
    
    init?(hieroglyph:String){
        if let a=self.arabischHieroglyphenDict
            .first(where: {_,n in
                return n == hieroglyph
            }){
            self.anzahl=a.key * multiplikator
        }
        else{
            return nil
        }
        
    }
}

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
    
    init?(hieroglyph:String){
        if let a=self.arabischHieroglyphenDict
            .first(where: {_,n in
                return n == hieroglyph
            }){
            self.anzahl=a.key * multiplikator
        }
        else{
            return nil
        }
        
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
    
    init?(hieroglyph:String){
        if let a=self.arabischHieroglyphenDict
            .sorted(by: {$0.value.count > $1.value.count})
            .first(where: {_,n in
                return n == hieroglyph
            }){
            self.anzahl=a.key * multiplikator
        }
        else{
            return nil
        }
        
    }
    
}

struct Millionen_Hieroglyphen: AlsHieroglyphenZahl{
    
    let anzahl:Int
    let multiplikator:Int = 1_000_000
    
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
    
    init?(hieroglyph:String){
        if let a=self.arabischHieroglyphenDict
            .sorted(by: {$0.value.count > $1.value.count})
            .first(where: {_,n in
                return n == hieroglyph
            }){
            self.anzahl=a.key * multiplikator
        }
        else{
            return nil
        }
        
    }
    
}


struct HieroglyphenZahl{
    
    let arabic:Int
    let hieroglyph:String
    
    init?(string:String){
        var number=0
        hieroglyph=string
        let units:[AlsHieroglyphenZahl.Type] = [Einer.self,Zehner.self,Hunderter.self,Tausender_Hieroglyphen.self,Zehntausender_Hieroglyphen.self,HundertTausender_Hieroglyphen.self,Millionen_Hieroglyphen.self]
        for char in string.reversed(){
            let unit=units.compactMap{
                $0.init(hieroglyph: String(char))
            }.first?.anzahl
            number += unit ?? 0
        }
        arabic=number
    }
    
    init?(Zahl:Int){
        arabic=Zahl
        guard Zahl > 0, Zahl < 10_000_000 else {
            return nil
        }
        
        let z:[AlsHieroglyphenZahl]=[Millionen_Hieroglyphen(Zahl: Zahl),
                                     HundertTausender_Hieroglyphen(Zahl: Zahl),
                                     Zehntausender_Hieroglyphen(Zahl: Zahl),
                                     Tausender_Hieroglyphen(Zahl: Zahl),
                                     Hunderter(Zahl: Zahl),
                                     Zehner(Zahl: Zahl),
                                     Einer(Zahl: Zahl)
        ]
        
        let text = z.reduce("", {r, z in
            r+z.hieroglyphe
        })
        hieroglyph=text
    }
}


struct AegeanZahl{
    
    let arabic:Int
    let aegean:String
    
    init?(string:String){
        var number=0
        self.aegean=string
        let units:[AlsAegaeischeZahl.Type] = [Einer.self,Zehner.self,Hunderter.self,JapanischeTausender.self,ZehnTausender.self]
        for char in string.reversed(){
            let unit=units.compactMap{
                $0.init(aegeanNumber:String(char))
            }.first?.anzahl
            number += unit ?? 0
        }
        arabic=number
    }
    
    init?(number:Int){
        self.arabic=number
        
        guard number > 0, number < 100_000 else {
            return nil
        }
        
        let z:[AlsAegaeischeZahl]=[ZehnTausender(Zahl: number),
                                   JapanischeTausender(Zahl: number),
                                   Hunderter(Zahl: number),
                                   Zehner(Zahl: number),
                                   Einer(Zahl: number)
        ]
        
        let text = z.reduce("", {r, z in
            r+z.aegean
        })
        aegean=text
    }
}
