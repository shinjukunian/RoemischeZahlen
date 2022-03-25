//
//  Cyrillic.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import Foundation

//http://prevodnik.gorazd.org/old-church-slavonic-numerals-converter-kb-info
public struct CyrillicNumber: Cyrillic{
    
    let arabic:Int
    let cyrillic:String
    
    init?(number: Int) {
        self.init(number: number, useMultiplicationModifiers: false)
    }
    
    init?(number:Int, useMultiplicationModifiers:Bool = false){
        if useMultiplicationModifiers || number > 1_000_000{
            guard let large=CyrilligLargeNumber(number: number)
            else{
                return nil
            }
            self.cyrillic=large.cyrillic
            self.arabic=number
            return
        }
        
        guard number != 0 else{
            return nil
        }
        
        self.arabic=number
        
        var parsed=number
        var multiplier = 1
        var components = [String]()
        
        while (parsed > 0){
            let thousandsCharacter = multiplier > 1 ? CyrillicNumber.thousandsSymbol : ""
            let pureHundreds=parsed.quotientAndRemainder(dividingBy: 1000).remainder
            let hundreds=pureHundreds.quotientAndRemainder(dividingBy: 100)
            let hundredsStrings=CyrillicNumber.table[hundreds.quotient * 100]
            
            let tensString:String?
            let onesString:String?
            
            if (11...19).contains(hundreds.remainder),
               multiplier == 1{
                tensString=CyrillicNumber.table[hundreds.remainder]
                onesString=nil
            }
            else{
                let tens=hundreds.remainder.quotientAndRemainder(dividingBy: 10)
                tensString=CyrillicNumber.table[tens.quotient * 10]
                onesString=CyrillicNumber.table[tens.remainder]
            }
            
            let text=[hundredsStrings,tensString,onesString]
                .compactMap({$0})
                .filter({$0.isEmpty == false})
                .map({thousandsCharacter + $0})
                .joined()
            components.append(text)
            parsed /= 1000
            multiplier *= 1000
        }
        
        let text=components.reversed().joined()
        cyrillic=text
    }
    
    
    init?(text:String){
        guard text.isEmpty == false else{
            return nil
        }
        
        self.cyrillic=CyrillicNumber.canonicalForm(text)
        var combined=Dictionary(uniqueKeysWithValues: zip(CyrillicNumber.table.values, CyrillicNumber.table.keys))
        let scalarsSet=Set(text.unicodeScalars)
        if scalarsSet.isDisjoint(with: CyrillicNumber.modifierSymbols) == false{
            combined = combined.merging(CyrilligLargeNumber.largeNumbersLookup, uniquingKeysWith: {s1,s2 in
                return s1
            })
        }
        
        
        var parsed=cyrillic.filter({$0.isWhitespace == false})
        var number = 0
        
        while (parsed.isEmpty == false){
            if let rangeItem=combined.compactMap({key, value -> (Range<String.Index>,Int)? in
                if let range=parsed.range(of: key, options: [.anchored,.backwards]){
                    // look ahead
                    if range.lowerBound > parsed.startIndex,
                       let offset=parsed.index(range.lowerBound, offsetBy: -1, limitedBy: parsed.startIndex){
                        let lookAhead=parsed[offset]
                        if String(lookAhead) == CyrillicNumber.thousandsSymbol{
                            let match=parsed[range]
                            let newRange=offset..<range.upperBound
                            if match.count == 1{ // we have matche a single token, this will be multiplied
                                return (newRange,value * 1000)
                            }
                            else{// the value is invalid, the multiplier only applies to the leftmost token
                                let newValue=match.enumerated().map({(idx,token) -> Int in
                                    let value=combined[String(token)] ?? 0
                                    return idx == 0 ? value * 1000 : value
                                }).reduce(0,+)
                                return (newRange,newValue)
                            }
                            
                        }
                        else{
                            return (range,value)
                        }
                    }
                    else{
                        return (range,value)
                    }
                    
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
        
    }
}
