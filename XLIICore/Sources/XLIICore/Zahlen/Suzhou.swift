//
//  Suzhou.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import Foundation

struct SuzhouZahl:AlsSuzhouZahl{
    
    var suzhou: String = ""
    
    var arabic:Int = 0
    
    init(Zahl:Int){
        arabic=Zahl
        let stringNumber=String(Zahl)
        var suzhouString=""
        var vertical:Bool=true
        var hasEncountered123 = false
        for char in stringNumber{
            guard let number=Int(String(char)) else { continue}
            let digit:String
            switch  number{
            case 1...3:
                if vertical{
                    digit = arabischSuzhouDict[number] ?? ""
                }
                else{
                    digit = alternativArabischSuzhouDict[number] ?? ""
                }
                hasEncountered123=true
            default:
                digit = arabischSuzhouDict[number] ?? ""
            }
            suzhouString.append(digit)
            
            if hasEncountered123{
                vertical.toggle()
            }
            
        }
        
        suzhou=suzhouString
    }
    
    init?(string:String) {
        guard string.potenzielleSuzhouZahl else{
            return nil
        }
        suzhou=string
        var lookupTable = [String:Int]()
        for item in arabischSuzhouDict{
            lookupTable[item.value]=item.key
        }
        for item in alternativArabischSuzhouDict{
            lookupTable[item.value]=item.key
        }
        var decimal=1
        for char in string.reversed(){
            let number=(lookupTable[String(char)] ?? 0) * decimal
            arabic+=number
            decimal*=10
        }
        
    }
    
}



