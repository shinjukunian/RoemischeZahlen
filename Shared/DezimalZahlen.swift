//
//  DezimalZahlen.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation

protocol AlsRoemischeZahl {
    var anzahl: Int {get}
    var arabischRömischDict: [Int:String] {get}
    var römisch: String {get}
}

extension AlsRoemischeZahl{
    var römisch : String{
        return self.arabischRömischDict[self.anzahl] ?? ""
    }
}

protocol AlsArabischeZahl{
    var arabisch:Int {get}
    var multiplikator: Int {get}
    var anzahl: Int {get}
}

extension AlsArabischeZahl{
    var arabisch:Int{
        return self.anzahl * multiplikator
    }
}

protocol AlsJapanischeZahl {
    var anzahl: Int {get}
    var arabischJapanischDict: [Int:String] {get}
    var japanisch: String {get}
}

extension AlsJapanischeZahl{
    var japanisch:String{
        return self.arabischJapanischDict[self.anzahl] ?? ""
    }
}

struct Einser: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl {
    let anzahl:Int
    let multiplikator:Int = 1
    
    let arabischRömischDict=[0:"",
              1:"I",
              2:"II",
              3:"III",
              4:"IV",
              5:"V",
              6:"VI",
              7:"VII",
              8:"VIII",
              9:"IX"
    ]
    
    let arabischJapanischDict = [0:"",
                                 1:"一",
                                 2:"二",
                                 3:"三",
                                 4:"四",
                                 5:"五",
                                 6:"六",
                                 7:"七",
                                 8:"八",
                                 9:"九",
    ]
    
    init(Zahl:Int){
        let zehner = Zahl / 10
        let übrigeEinser = Zahl - 10 * zehner
        anzahl = übrigeEinser / multiplikator
    }
    
    init(römischeZahl:String) {
        switch römischeZahl {
        case _ where römischeZahl.range(of: "VIII", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=8
        case _ where römischeZahl.range(of: "VII", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
            self.anzahl=7
        case _ where römischeZahl.range(of: "VI", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=6
        case _ where römischeZahl.range(of: "IX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=9
        case _ where römischeZahl.range(of: "IV", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=4
        case _ where römischeZahl.range(of: "III", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=3
        case _ where römischeZahl.range(of: "II", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=2
        case _ where römischeZahl.range(of: "I", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=1
        case _ where römischeZahl.range(of: "V", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
            self.anzahl=5
        default:
            self.anzahl=0
        }
    }
    
    init(japanischeZahl:String) {
        let a=self.arabischJapanischDict
            .first(where: {_,n in
                if japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive], range: nil, locale: nil) != nil{
                    return true
                }
                return false
            })
        
        self.anzahl=a?.key ?? 0
    }
    
}

struct Zehner: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl{
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
        let a=self.arabischJapanischDict
            .sorted(by: {$0.0 > $1.0})
            .first(where: {_,n in
                if japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive], range: nil, locale: nil) != nil{
                    return true
                }
                return false
            })
        
        self.anzahl=a?.key ?? 0
    }
    
}


struct Hunderter: AlsRoemischeZahl, AlsArabischeZahl, AlsJapanischeZahl {
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
        let a=self.arabischJapanischDict
            .sorted(by: {$0.0 > $1.0})
            .first(where: {_,n in
                if japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive], range: nil, locale: nil) != nil{
                    return true
                }
                return false
            })
        
        self.anzahl=a?.key ?? 0
    }
}


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
        default:
            return Array(repeating: "M", count: anzahl).joined()
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

struct JapanischeTausender: AlsJapanischeZahl, AlsArabischeZahl{
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
    
    init(japanischeZahl:String) {
        let a=self.arabischJapanischDict
            .sorted(by: {$0.0 > $1.0})
            .first(where: {_,n in
                if japanischeZahl.range(of: n, options: [.caseInsensitive, .anchored, .backwards, .widthInsensitive], range: nil, locale: nil) != nil{
                    return true
                }
                return false
            })
        
        self.anzahl=a?.key ?? 0
    }
}


struct ZehnTausender: AlsArabischeZahl, AlsJapanischeZahl{
    let anzahl:Int
    let multiplikator:Int = 10000
    
    let arabischJapanischDict = [Int:String]()
    
    init(Zahl:Int){
        let hundertMillionen = Zahl / (multiplikator*100_000_000)
        let restlicheZehnTausender = Zahl - hundertMillionen * (multiplikator*100_000_000)
        let zehnTausender = restlicheZehnTausender / multiplikator
        anzahl = zehnTausender
    }
    
    var japanisch: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten,
                                   Hunderter(Zahl: anzahl).japanisch,
                                   Zehner(Zahl: anzahl).japanisch,
                                   Einser(Zahl: anzahl).japanisch]
        return z.reduce("", {r, z in
            r+z
        }) + "万"
    }
    
    init(japanischeZahl:String) {
        var restZahl=japanischeZahl.replacingOccurrences(of: "万", with: "")
        
        let einser=Einser(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: einser.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let zehner=Zehner(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehner.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let hunderter=Hunderter(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hunderter.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let tausender=JapanischeTausender(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tausender.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        
        let komponenten:[AlsArabischeZahl]=[tausender,hunderter,zehner,einser]
        self.anzahl=komponenten.reduce(0, {r,z in
            r+z.arabisch
        })
    }
}

struct HundertMillionen: AlsArabischeZahl, AlsJapanischeZahl{
    let anzahl:Int
    let multiplikator:Int = 100_000_000
    
    let arabischJapanischDict = [Int:String]()
    
    init(Zahl:Int){
        let hundertMillionen = Zahl / multiplikator
        anzahl = hundertMillionen
    }
    
    var japanisch: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[ZehnTausender(Zahl: anzahl).japanisch, JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten,
                                   Hunderter(Zahl: anzahl).japanisch,
                                   Zehner(Zahl: anzahl).japanisch,
                                   Einser(Zahl: anzahl).japanisch]
        return z.reduce("", {r, z in
            r+z
        }) + "億"
    }
    
    init(japanischeZahl:String) {
        var restZahl=japanischeZahl.replacingOccurrences(of: "億", with: "")
        
        let einser=Einser(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: einser.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let zehner=Zehner(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehner.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let hunderter=Hunderter(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hunderter.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        let tausender=JapanischeTausender(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tausender.japanisch, with: "", options: [.anchored,.backwards,.widthInsensitive], range: nil)
        
        let komponenten:[AlsArabischeZahl]=[tausender,hunderter,zehner,einser]
        self.anzahl=komponenten.reduce(0, {r,z in
            r+z.arabisch
        })
    }
}
