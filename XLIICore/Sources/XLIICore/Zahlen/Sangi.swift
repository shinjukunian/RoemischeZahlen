//
//  Sangi.swift
//  
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation

struct SangiNumber{
    let onesDict: [Int : String] = [0:"〇",
                                    1:"𝍠",
                                    2:"𝍡",
                                    3:"𝍢",
                                    4:"𝍣",
                                    5:"𝍤",
                                    6:"𝍥",
                                    7:"𝍦",
                                    8:"𝍧",
                                    9:"𝍨"
    ]
    
    let tensDict: [Int : String] = [0:"〇",
                                    1:"𝍩",
                                    2:"𝍪",
                                    3:"𝍫",
                                    4:"𝍬",
                                    5:"𝍭",
                                    6:"𝍮",
                                    7:"𝍯",
                                    8:"𝍰",
                                    9:"𝍱"
    ]
    
    let sangi:String
    let arabic:Int
    
    init(number:Int){
        self.arabic=number
        guard number != 0 else{
            sangi=onesDict[0]!
            return
        }
        
        var components:[String]=[String]()
        var parsed=number
        var useVertical=true
        
        
        while (parsed > 0){
            let div=parsed.quotientAndRemainder(dividingBy: 10)
            let text:String
            if useVertical{
                text=onesDict[div.remainder] ?? ""
            }
            else{
                text=tensDict[div.remainder] ?? ""
            }
            components.append(text)
            useVertical.toggle()
            parsed=div.quotient
        }
        
        sangi=components.reversed().joined()
        
    }
    
    init?(text:String){
        self.sangi=text
        
        var number=0
        var multiplier=1
        var parsed=text
        var useVertical = true
        
        let vertDict=Dictionary(uniqueKeysWithValues: zip(onesDict.values,onesDict.keys))
        let horDict=Dictionary(uniqueKeysWithValues: zip(tensDict.values,tensDict.keys))
        
        while(parsed.isEmpty == false){
            guard let c = parsed.popLast() else{
                break
            }
            let char=String(c)
            let n:Int?
            if useVertical{
                n=vertDict[char]
            }
            else{
                n=horDict[char]
            }
            
            guard let n=n else{
                return nil
            }
            
            number += n * multiplier
            multiplier *= 10
            useVertical.toggle()
        }
        
        self.arabic=number
    }
}
