//
//  TibetanNumber.swift
//  
//
//  Created by Morten Bertz on 2022/03/08.
//

import Foundation

struct TibetanNumber{
    let arabic:Int
    let tibetan:String

    let table = [0:"༠",1:"༡",2:"༢",3:"༣",4:"༤",5:"༥",6:"༦",7:"༧",8:"༨",9:"༩"]
    
    init(number:Int){
        self.arabic=number
        guard number != 0 else{
            tibetan=table[0]!
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
        
        tibetan = components.reversed().joined()
    }
    
    init?(string:String){
        tibetan=string
        
        var number=0
        var multiplier=1
        
        var parsed=string
        
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


struct MongolianNumber{
    let arabic:Int
    let mongolian:String

    let table = [0:"᠐",1:"᠑",2:"᠒",3:"᠓",4:"᠔",5:"᠕",6:"᠖",7:"᠗",8:"᠘",9:"᠙"]
    
    init(number:Int){
        self.arabic=number
        guard number != 0 else{
            mongolian=table[0]!
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
        
        mongolian = components.reversed().joined()
    }
    
    init?(string:String){
        mongolian=string
        
        var number=0
        var multiplier=1
        
        var parsed=string
        
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
