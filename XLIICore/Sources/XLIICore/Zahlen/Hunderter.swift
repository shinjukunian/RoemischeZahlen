//
//  Hunderter.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation

struct Hunderter: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl, AlsAegaeischeZahl, AlsHieroglyphenZahl {
    let anzahl:Int
    let multiplikator:Int64 = 100
    
    let arabischRömischDict=[0:"",
                             1:"C",
                             2:"CC",
                             3:"CCC",
                             4:"CD",
                             5:"D",
                             6:"DC",
                             7:"DCC",
                             8:"DCCC",
                             9:"CM"
    ]
    
    let arabischJapanischDict = [0:"",
                                 1:"百",
                                 2:"二百",
                                 3:"三百",
                                 4:"四百",
                                 5:"五百",
                                 6:"六百",
                                 7:"七百",
                                 8:"八百",
                                 9:"九百",
    ]
    
    let arabischJapanischBankDict: [Int : String] = [0:"",
                                                     1:"陌",
                                                     2:"弐陌",
                                                     3:"参陌",
                                                     4:"肆陌",
                                                     5:"伍陌",
                                                     6:"陸陌",
                                                     7:"漆陌",
                                                     8:"捌陌",
                                                     9:"玖陌",
    ]
    
    var arabischJapanischBankDict_einfach: [Int : String] = [0:"",
                                                             1:"百",
                                                             2:"弐百",
                                                             3:"参百",
                                                             4:"四百",
                                                             5:"五百",
                                                             6:"六百",
                                                             7:"七百",
                                                             8:"八百",
                                                             9:"九百",
    ]
    
    let arabischAegeanDict: [Int : String] = [0:"",
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
    
    
    let arabischHieroglyphenDict: [Int : String] = [0:"",
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
    
    init(Zahl:Int){
        let tausnder = Zahl / 1000
        let übrigehunderter = Zahl - 1000 * tausnder
        anzahl = übrigehunderter / Int(multiplikator)
    }
    
    init(römischeZahl:String) {
        switch römischeZahl {
        case _ where römischeZahl.range(of: "DCCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=8
        case _ where römischeZahl.range(of: "DCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=7
        case _ where römischeZahl.range(of: "DC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=6
        case _ where römischeZahl.range(of: "CM", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=9
        case _ where römischeZahl.range(of: "CD", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=4
        case _ where römischeZahl.range(of: "CCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=3
        case _ where römischeZahl.range(of: "CC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=2
        case _ where römischeZahl.range(of: "C", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=1
        case _ where römischeZahl.range(of: "D", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=5
        default:
            self.anzahl=0
        }
    }
    
    init(japanischeZahl:String) {
        let a=[self.arabischJapanischDict, self.arabischJapanischBankDict, self.arabischJapanischBankDict_einfach]
            .map{
                $0.compactMap({value,n->(Range<String.Index>,Int)? in
                    if let range=japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive]){
                        return (range,value)
                    }
                    return nil
                })
            }
            .flatMap({$0})
            .min(by: {r1,r2 in
                r1.0.lowerBound < r2.0.lowerBound
            })
        
        self.anzahl=a?.1 ?? 0
    }
    
    init?(hieroglyph:String){
        if let a=self.arabischHieroglyphenDict
            .first(where: {_,n in
                return n == hieroglyph
            }){
            self.anzahl=a.key * Int(multiplikator)
        }
        else{
            return nil
        }
        
    }
    
    init?(aegeanNumber:String){
        if let a=self.arabischAegeanDict
            .first(where: {_,n in
                return n == aegeanNumber
            }){
            self.anzahl=a.key * Int(multiplikator)
        }
        else{
            return nil
        }
        
    }
}
