//
//  Kharosthi.swift
//  
//
//  Created by Morten Bertz on 2022/02/26.
//

import Foundation
import simd

struct KharosthiNumber{
    

    let kharosthi:String
    let arabic:Int
    
    let onesDict = [0:"",
                               1:"𐩀",
                               2:"𐩁",
                               3:"𐩂",
                               4:"𐩃",
                               5:"𐩃𐩀",
                               6:"𐩃𐩁",
                               7:"𐩃𐩂",
                               8:"𐩃𐩃",
                               9:"𐩃𐩃𐩀",
]
    
    let tenSymbol = "𐩄"
    let twentySymbol="𐩅"
    let hundredSymbol = "𐩆"
    let thousandSymbol = "𐩇"
    
    init?(number:Int){
        guard (1..<10_000_000).contains(number) else{
            return nil
        }
        self.arabic=number
        
        var parsed=number
        
        var components:[String] = [String]()
        
        while(parsed > 0){
            
            let div1000 = parsed.quotientAndRemainder(dividingBy: 1000)
            let div100 = div1000.remainder.quotientAndRemainder(dividingBy: 100)
            let div20 = div100.remainder.quotientAndRemainder(dividingBy: 20)
            let div10 = div20.remainder.quotientAndRemainder(dividingBy: 10)
            
            let thousandString = div1000.quotient > 0 ? thousandSymbol : ""
            
            
            let hundredsString:String
            
            switch div100.quotient{
            case 0:
                hundredsString = ""
            case 1:
                hundredsString = hundredSymbol
            default:
                hundredsString = (onesDict[div100.quotient] ?? "") + hundredSymbol
            }
            
            let twentiesString=Array(repeating: twentySymbol, count: div20.quotient).joined()
            let tensString=Array(repeating: tenSymbol, count: div10.quotient).joined()
            let onesString=onesDict[div10.remainder] ?? ""
            
            
            let text=thousandString + hundredsString + twentiesString + tensString + onesString
            components.append(text)
            parsed /= 1000
        }
        
        //strip leading one
        let onesCharacter=onesDict[1]!
        let result=components.reversed().joined()
        
        if result.count > 1{
            kharosthi = String(result.drop(while: {String($0) == onesCharacter}))
        }
        else{
            kharosthi = result
        }
        
    }
    
    
    
    init?(string:String){
        
        guard string.potentielleKharosthiZahl else{
            return nil
        }
        
        self.kharosthi=string
        
        var number=0
        
        var multiplier=1
        
        var parsed=string
        
        let s20=twentySymbol
        let s100=hundredSymbol
        
        
        let singlesLookup=onesDict.sorted(by: {$0.0 > $1.0})
        
        
        while (parsed.isEmpty == false){
            let thousandsRange=parsed.range(of: thousandSymbol, options: [.backwards])
            
            let thousands:Int
            
            let substringStart=thousandsRange?.lowerBound ?? parsed.startIndex
            let substringRange=substringStart..<parsed.endIndex
            let substring=parsed[substringRange]
            
            if parsed.hasPrefix(thousandSymbol){
                thousands = 1 * multiplier
            }
            else{
                thousands = 0
            }
            
            let ones=singlesLookup.first(where: {_, n in
                substring.range(of: n, options: [.anchored,.backwards], range: substring.startIndex..<substring.endIndex, locale: nil) != nil
            })?.key ?? 0
            
            let tens=substring.contains(tenSymbol) ? 1 : 0
            
            let twenties=substring.filter({char in
                String(char) == s20
            }).count
            
            let hundreds = {()->Int in
                if let r=substring.range(of: s100){
                    let toEnd=substring.startIndex..<r.upperBound
                    let hundredsString=String(substring[toEnd])
                    let ones=singlesLookup.first(where: {_, n in
                        hundredsString.range(of: n, options: [], range: hundredsString.startIndex..<hundredsString.endIndex, locale: nil) != nil
                    })?.key ?? 1
                    return ones
                }
                return 0
            }()
            
            
            let sum = ones + tens * 10 + twenties * 20 + hundreds * 100 + thousands * 1000
            number += sum * multiplier
            
            multiplier *= 1000
            
            
            parsed = String(parsed[parsed.startIndex..<substringStart])
            
        }
        
        
        
        
        
        arabic=number
        
    }
    
}
