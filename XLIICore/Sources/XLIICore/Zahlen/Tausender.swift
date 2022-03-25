//
//  Tausender.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation


struct Tausender: AlsArabischeZahl{
    let anzahl:Int
    let multiplikator:Int64 = 1000
    
    init(Zahl:Int){
        let tausnder = Zahl / Int(multiplikator)
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
            let doubleOverbar=String(Unicode.Scalar(0x033F)!)
//            let overbar=String(Unicode.Scalar(0xFE26)!)
            if tausender.anzahl > 0{
                let milZehner = Zehner(Zahl: tausender.anzahl)
                let milEinser = Einer(Zahl: tausender.anzahl)
                let milHunderter = Hunderter(Zahl: tausender.anzahl)
                let mil = milHunderter.römisch + milZehner.römisch + milEinser.römisch
                
                let overbarMillions=mil.map({c in
                    return String(c) + doubleOverbar
                })
                millions = overbarMillions.joined()
                
            }
            else{
                millions = ""
            }
            
            let roemischeTausender = hunderter.römisch + zehner.römisch + einser.römisch
            let overbar=String(Unicode.Scalar(0xFE26)!)
            let overbarTausender=roemischeTausender.map({c in
                return String(c) + overbar
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


struct JapanischeTausender: AlsJapanischeZahl, AlsArabischeZahl, AlsJapanischeBankZahl, AlsAegaeischeZahl{
    
    let anzahl:Int
    let multiplikator:Int64 = 1000
    
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
    
    let arabischAegeanDict: [Int : String] = [0:"",
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
    
    
    init(Zahl:Int){
        let zehnTausender = Zahl / (Int(multiplikator)*10)
        let restlicheTausender = Zahl - zehnTausender * (Int(multiplikator)*10)
        let tausnder = restlicheTausender / Int(multiplikator)
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
