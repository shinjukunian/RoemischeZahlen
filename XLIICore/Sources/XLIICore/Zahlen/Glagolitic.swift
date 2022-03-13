//
//  Glagolitic.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import Foundation

struct GlagoliticNumer{
    let arabic:Int
    let glacolitic:String
    
    
    let table = [0:"",
                 1:"Ⰰ",
                 2:"Ⰱ",
                 3:"Ⰲ",
                 4:"Ⰳ",
                 5:"Ⰴ",
                 6:"Ⰵ",
                 7:"Ⰶ",
                 8:"Ⰷ",
                 9:"Ⰸ",
                 10:"Ⰺ",
                 11:"ⰀⰊ",
                 12:"ⰁⰊ",
                 13:"ⰂⰊ",
                 14:"ⰃⰊ",
                 15:"ⰄⰊ",
                 16:"ⰅⰊ",
                 17:"ⰆⰊ",
                 18:"ⰇⰊ",
                 19:"ⰈⰊ",
                 20:"Ⰻ",
                 30:"Ⰼ",
                 40:"Ⰽ",
                 50:"Ⰾ",
                 60:"Ⰿ",
                 70:"Ⱀ",
                 80:"Ⱁ",
                 90:"Ⱂ",
                 100:"Ⱃ",
                 200:"Ⱄ",
                 300:"Ⱅ",
                 400:"Ⱆ",
                 500:"Ⱇ",
                 600:"Ⱈ",
                 700:"Ⱉ",
                 800:"Ⱋ",
                 900:"Ⱌ",
                 1000:"Ⱍ",
                 2000:"Ⱎ",
                 3000:"Ⱏ"
                 
    ]
    
    init?(number:Int){
        guard (1..<4000).contains(number) else{
            return nil
        }
        self.arabic = number
        
        let thousands=number.quotientAndRemainder(dividingBy: 1000)
        let thousandsString=table[thousands.quotient * 1000]
        let hundreds=thousands.remainder.quotientAndRemainder(dividingBy: 100)
        let hundredsStrings=table[hundreds.quotient * 100]
        
        let tensString:String?
        let onesString:String?
        
        if (11...19).contains(hundreds.remainder){
            tensString=table[hundreds.remainder]
            onesString=nil
        }
        else{
            let tens=hundreds.remainder.quotientAndRemainder(dividingBy: 10)
            tensString=table[tens.quotient * 10]
            onesString=table[tens.remainder]
        }
        
        let text=[thousandsString,hundredsStrings,tensString,onesString].compactMap({$0}).joined()

        glacolitic=text
    }
    
    init?(string:String){
        guard string.isEmpty == false else{
            return nil
        }
        
        let combined=Dictionary(uniqueKeysWithValues: zip(table.values,table.keys))
        
        var parsed=string
        var number=0
        
        while (parsed.isEmpty == false){
            if let rangeItem=combined.compactMap({key, value -> (Range<String.Index>,Int)? in
                if let range=parsed.range(of: key, options: [.anchored,.backwards]){
                    return (range,value)
                }
                else{
                    return nil
                }
            }).min(by: {r1,r2 in
                r1.0.lowerBound < r2.0.lowerBound
            }){
                let range=rangeItem.0
                let value=rangeItem.1
                parsed = String(parsed[parsed.startIndex..<range.lowerBound])
                number += value
            }
            else{
                return nil
            }
            
        }
        
        arabic=number
        glacolitic=string
    }
}
