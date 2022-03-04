//
//  ZehnTausender.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/09/14.
//

import Foundation


struct ZehnTausender: AlsArabischeZahl, AlsJapanischeZahl, AlsJapanischeBankZahl, AlsAegaeischeZahl{
    let anzahl:Int
    let multiplikator:Int64 = 10000
    
    let arabischJapanischDict = [Int:String]()
    var arabischJapanischBankDict = [Int : String]()
    
    var arabischJapanischBankDict_einfach = [Int : String]()
    
    let arabischAegeanDict: [Int : String] = [0:"",
                                              1:"𐄫",
                                              2:"𐄬",
                                              3:"𐄭",
                                              4:"𐄮",
                                              5:"𐄯",
                                              6:"𐄰",
                                              7:"𐄱",
                                              8:"𐄲",
                                              9:"𐄳"
    ]
    
   
    
    init(Zahl:Int){
        let hundertMillionen = Zahl / 100_000_000
        let restlicheZehnTausender = Zahl - hundertMillionen * 100_000_000
        let zehnTausender = restlicheZehnTausender / Int(multiplikator)
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
        let manSet=Set(["万","萬"])
        var restZahl=String(japanischeZahl.trimmingSuffix(while: {manSet.contains(String($0))}))
        
        
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
