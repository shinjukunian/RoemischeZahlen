//
//  DezimalZahlen.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation

protocol AlsZahl {
    var anzahl: Int {get}
}

protocol AlsRoemischeZahl: AlsZahl {
    var arabischRömischDict: [Int:String] {get}
    var römisch: String {get}
}

protocol AlsBabylonischeZahl: AlsZahl {
    var arabischBabylonischDict: [Int:String] {get}
    var babylonisch: String {get}
}

protocol AlsAegaeischeZahl: AlsZahl {
    var arabischAegeanDict: [Int:String] {get}
    var aegean: String {get}
    init?(aegeanNumber:String)
}

protocol AlsSangiZahl: AlsZahl {
    var arabischSangiDict: [Int:String] {get}
    var sangi: String {get}
}

protocol AlsHieroglyphenZahl: AlsZahl {
    var arabischHieroglyphenDict: [Int:String] {get}
    var hieroglyphe: String {get}
    init?(hieroglyph:String)
}


protocol AlsSuzhouZahl {
    var arabischSuzhouDict: [Int:String] {get}
    var alternativArabischSuzhouDict:[Int:String] {get}
    var suzhou: String {get}
}


extension AlsSuzhouZahl{
    var arabischSuzhouDict: [Int : String] { [0:"〇",
                                              1:"〡",
                                              2:"〢",
                                              3:"〣",
                                              4:"〤",
                                              5:"〥",
                                              6:"〦",
                                              7:"〧",
                                              8:"〨",
                                              9:"〩"]
    }
    
    var alternativArabischSuzhouDict: [Int : String] { [1:"一", 2:"二", 3:"三"] }
}

extension AlsHieroglyphenZahl{
    var hieroglyphe : String{
        return self.arabischHieroglyphenDict[self.anzahl] ?? ""
    }
}

extension AlsRoemischeZahl{
    var römisch : String{
        return self.arabischRömischDict[self.anzahl] ?? ""
    }
}

extension AlsAegaeischeZahl{
    var aegean: String{
        return self.arabischAegeanDict[self.anzahl] ?? ""
    }
}

extension AlsSangiZahl{
    var sangi: String{
        return self.arabischSangiDict[self.anzahl] ?? ""
    }
}

extension AlsBabylonischeZahl{
    var babylonisch:String{
        return self.arabischBabylonischDict[self.anzahl] ?? ""
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

protocol AlsJapanischeZahl: AlsZahl {
    var arabischJapanischDict: [Int:String] {get}
    var japanisch: String {get}
}

extension AlsJapanischeZahl{
    var japanisch:String{
        return self.arabischJapanischDict[self.anzahl] ?? ""
    }
}

protocol AlsJapanischeBankZahl: AlsJapanischeZahl {
    var arabischJapanischBankDict: [Int:String] {get}
    var arabischJapanischBankDict_einfach: [Int:String] {get}
    var japanisch_Bank:String {get}
    var japanisch_Bank_einfach:String {get}
}

extension AlsJapanischeBankZahl{
    var japanisch_Bank:String{
        return self.arabischJapanischBankDict[self.anzahl] ?? ""
    }
    
    var japanisch_Bank_einfach:String{
        return self.arabischJapanischBankDict_einfach[self.anzahl] ?? ""
    }
}
