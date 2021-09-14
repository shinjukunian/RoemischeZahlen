//
//  Zehner.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation

struct Zehner: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl{
    let anzahl:Int
    let multiplikator:Int = 10
    let arabischRömischDict=[0:"",
              1:"X",
              2:"XX",
              3:"XXX",
              4:"XL",
              5:"L",
              6:"LX",
              7:"LXX",
              8:"LXXX",
              9:"XC"
    ]
    
    let arabischJapanischDict = [0:"",
                                 1:"十",
                                 2:"二十",
                                 3:"三十",
                                 4:"四十",
                                 5:"五十",
                                 6:"六十",
                                 7:"七十",
                                 8:"八十",
                                 9:"九十",
    ]
    
    let arabischJapanischBankDict: [Int : String] = [0:"",
                                                    1:"拾",
                                                    2:"弐拾",
                                                    3:"参拾",
                                                    4:"肆拾",
                                                    5:"伍拾",
                                                    6:"陸拾",
                                                    7:"漆拾",
                                                    8:"捌拾",
                                                    9:"玖拾",
    ]
    
    var arabischJapanischBankDict_einfach: [Int : String] = [0:"",
                                                             1:"拾",
                                                             2:"弐拾",
                                                             3:"参拾",
                                                             4:"四拾",
                                                             5:"五拾",
                                                             6:"六拾",
                                                             7:"七拾",
                                                             8:"八拾",
                                                             9:"九拾",
                                ]
    
    init(Zahl:Int){
        let hunderter = Zahl / 100
        let übrigeZehner = Zahl - 100 * hunderter
        anzahl = übrigeZehner / multiplikator
    }
    
    init(römischeZahl:String) {
        switch römischeZahl {
        case _ where römischeZahl.range(of: "LXXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=8
        case _ where römischeZahl.range(of: "LXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=7
        case _ where römischeZahl.range(of: "LX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=6
        case _ where römischeZahl.range(of: "XC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=9
        case _ where römischeZahl.range(of: "XL", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=4
        case _ where römischeZahl.range(of: "XXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=3
        case _ where römischeZahl.range(of: "XX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=2
        case _ where römischeZahl.range(of: "X", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=1
        case _ where römischeZahl.range(of: "L", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
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
