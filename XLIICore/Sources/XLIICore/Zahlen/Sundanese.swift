//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/03/08.
//

import Foundation

struct SundaneseNumber{
    
    let arabic:Int
    let sundanese:String
    
    let table = [0:"᮰",
                 1:"᮱",
                 2:"᮲",
                 3:"᮳",
                 4:"᮴",
                 5:"᮵",
                 6:"᮶",
                 7:"᮷",
                 8:"᮸",
                 9:"᮹"]
    
    let seperator = "|"
    
    init(number:Int){
        self.arabic=number
        guard number != 0 else{
            sundanese=table[0]!
            return
        }
        var parsed=number
        var components=[String]()
        
        while (parsed > 0){
            let div=parsed.quotientAndRemainder(dividingBy: 10)
            let numeral=table[div.remainder] ?? ""
            components.append(numeral)
            parsed = div.quotient
        }
        
        sundanese = seperator + components.reversed().joined() + seperator
    }
    
    init?(string:String){
        sundanese=string
        
        var number=0
        var multiplier=1
        
        let sep=seperator
        var parsed=string.filter({String($0) != sep})
        
        let revesedTable=Dictionary(uniqueKeysWithValues: zip(table.values, table.keys))
        
        while (parsed.isEmpty == false){
            guard let current=parsed.popLast() else{
                break
            }
            number += (revesedTable[String(current)] ?? 0) * multiplier
            multiplier *= 10
        }
        
        
        arabic=number
    }
    
}
