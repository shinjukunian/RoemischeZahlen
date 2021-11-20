//
//  ZehnTausender.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation


struct ZehnTausender: AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl{
    let anzahl:Int
    let multiplikator:Int = 10000
    
    let arabischJapanischDict = [Int:String]()
    var arabischJapanischBankDict = [Int : String]()
    
    var arabischJapanischBankDict_einfach = [Int : String]()
    
    init(Zahl:Int){
        let hundertMillionen = Zahl / 100_000_000
        let restlicheZehnTausender = Zahl - hundertMillionen * 100_000_000
        let zehnTausender = restlicheZehnTausender / multiplikator
        anzahl = zehnTausender
    }
    
    var japanisch: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten,
                                   Hunderter(Zahl: anzahl).japanisch,
                                   Zehner(Zahl: anzahl).japanisch,
                                   Einer(Zahl: anzahl).japanisch]
        return z.reduce("", {r, z in
            r+z
        }) + "万"
    }
    
    
    var japanisch_Bank: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten_Bank,
                                   Hunderter(Zahl: anzahl).japanisch_Bank,
                                   Zehner(Zahl: anzahl).japanisch_Bank,
                                   Einer(Zahl: anzahl).japanisch_Bank]
        return z.reduce("", {r, z in
            r+z
        }) + "萬"
    }
    
    var japanisch_Bank_einfach: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten_Bank_einfach,
                                   Hunderter(Zahl: anzahl).japanisch_Bank_einfach,
                                   Zehner(Zahl: anzahl).japanisch_Bank_einfach,
                                   Einer(Zahl: anzahl).japanisch_Bank_einfach]
        return z.reduce("", {r, z in
            r+z
        }) + "万"
    }
    
    init(japanischeZahl:String) {
        var restZahl=japanischeZahl.replacingOccurrences(of: "万", with: "")
        restZahl=japanischeZahl.replacingOccurrences(of: "萬", with: "")
        
        let einser=Einer(japanischeZahl: restZahl)
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
