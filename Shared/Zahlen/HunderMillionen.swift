//
//  HunderMillionen.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation


struct HundertMillionen: AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl{
   
    let anzahl:Int
    let multiplikator:Int = 100_000_000
    
    var arabischJapanischBankDict = [Int : String]()
    
    var arabischJapanischBankDict_einfach = [Int : String]()
    
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
                                   Einer(Zahl: anzahl).japanisch]
        return z.reduce("", {r, z in
            r+z
        }) + "億"
    }
    
    init(japanischeZahl:String) {
        var restZahl=japanischeZahl.replacingOccurrences(of: "億", with: "")
        
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
    
    var japanisch_Bank_einfach: String{
        guard anzahl > 0 else {return ""}
        
        let z:[String]=[ZehnTausender(Zahl: anzahl).japanisch_Bank_einfach,
                        JapanischeTausender(Zahl: anzahl).japanischMitTausenderEinheiten_Bank_einfach,
                        Hunderter(Zahl: anzahl).japanisch_Bank_einfach,
                        Zehner(Zahl: anzahl).japanisch_Bank_einfach,
                        Einer(Zahl: anzahl).japanisch_Bank_einfach]
        return z.reduce("", {r, z in
            r+z
        }) + "億"
    }
}
