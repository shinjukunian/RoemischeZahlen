//
//  Hunderter.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation

struct Hunderter: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl {
    let anzahl:Int
    let multiplikator:Int = 100
    
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
    
    
    init(Zahl:Int){
        let tausnder = Zahl / 1000
        let übrigehunderter = Zahl - 1000 * tausnder
        anzahl = übrigehunderter / multiplikator
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
        let a=[self.arabischJapanischDict,
               self.arabischJapanischBankDict]
            .compactMap {
                $0.sorted(by: {$0.0 > $1.0})
                    .first(where: {_,n in
                        if japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive], range: nil, locale: nil) != nil{
                            return true
                        }
                        return false
                    })
            }
        
        self.anzahl=a.first?.key ?? 0
    }
}
