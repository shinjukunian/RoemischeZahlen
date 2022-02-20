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

protocol AlsBabylonischeZahl {
    var anzahl: Int {get}
    var arabischBabylonischDict: [Int:String] {get}
    var babylonisch: String {get}
}

protocol AlsAegaeischeZahl {
    var anzahl: Int {get}
    var arabischAegeanDict: [Int:String] {get}
    var aegean: String {get}
}

protocol AlsSangiZahl {
    var anzahl: Int {get}
    var arabischSangiDict: [Int:String] {get}
    var sangi: String {get}
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
