//
//  Tausender.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation


struct Tausender: AlsArabischeZahl{
    let anzahl:Int
    let multiplikator:Int = 1000
    
    init(Zahl:Int){
        let tausnder = Zahl / multiplikator
        anzahl = tausnder
    }
    
    var römisch : String{
        switch anzahl {
        case 0:
            return ""
        case 1...3:
            return Array(repeating: "M", count: anzahl).joined()
        
        default:
            let zehner = Zehner(Zahl: anzahl)
            let einser = Einer(Zahl: anzahl)
            let hunderter = Hunderter(Zahl: anzahl)
            
            let tausender = Tausender(Zahl: anzahl)
            let millions:String
            
            if tausender.anzahl > 0{
                let milZehner = Zehner(Zahl: tausender.anzahl)
                let milEinser = Einer(Zahl: tausender.anzahl)
                let milHunderter = Hunderter(Zahl: tausender.anzahl)
                let mil = milHunderter.römisch + milZehner.römisch + milEinser.römisch
                let overbar=Unicode.Scalar(0x033F)!
                let overbarMillions=mil.map({c in
                    return String(c) + String(overbar)
                })
                millions = overbarMillions.joined()

            }
            else{
                millions = ""
            }
            
            let roemischeTausender = hunderter.römisch + zehner.römisch + einser.römisch
            let overbar=Unicode.Scalar(0x0305)!
            let overbarTausender=roemischeTausender.map({c in
                return String(c) + String(overbar)
            })
            return millions + overbarTausender.joined()
        }
    }
    
    init(römischeZahl:String){
        var gefundeneMs=0
        for buchstabe in römischeZahl{
            if buchstabe.lowercased() == "m"{
                gefundeneMs+=1
            }
            else{
                anzahl=0
                return
            }
        }
        anzahl=gefundeneMs
    }
}


struct JapanischeTausender: AlsJapanischeZahl, AlsArabischeZahl, AlsJapanischeBankZahl{
    
    let anzahl:Int
    let multiplikator:Int = 1000
    
    let arabischJapanischDict = [0:"",
                                 1:"千",
                                 2:"二千",
                                 3:"三千",
                                 4:"四千",
                                 5:"五千",
                                 6:"六千",
                                 7:"七千",
                                 8:"八千",
                                 9:"九千",
    ]
    
    let arabischJapanischBankDict: [Int : String] = [0:"",
                                                     1:"阡",
                                                     2:"弐阡",
                                                     3:"参阡",
                                                     4:"肆阡",
                                                     5:"伍阡",
                                                     6:"陸阡",
                                                     7:"漆阡",
                                                     8:"捌阡",
                                                     9:"玖阡",
    ]
    
    var arabischJapanischBankDict_einfach: [Int : String] = [0:"",
                                                             1:"壱千",
                                                             2:"弐千",
                                                             3:"参千",
                                                             4:"四千",
                                                             5:"五千",
                                                             6:"六千",
                                                             7:"七千",
                                                             8:"八千",
                                                             9:"九千",
                                ]
    
    init(Zahl:Int){
        let zehnTausender = Zahl / (multiplikator*10)
        let restlicheTausender = Zahl - zehnTausender * (multiplikator*10)
        let tausnder = restlicheTausender / multiplikator
        anzahl = tausnder
    }
    
    var japanischMitTausenderEinheiten:String{
        switch anzahl {
        case 1:
            return "一千"
        default:
            return self.japanisch
        }
    }
    
    var japanischMitTausenderEinheiten_Bank:String{
        switch anzahl {
        case 1:
            return "壱阡"
        default:
            return self.japanisch_Bank
        }
    }
    
    var japanischMitTausenderEinheiten_Bank_einfach:String{
        switch anzahl {
        case 1:
            return "壱千"
        default:
            return self.japanisch_Bank_einfach
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
