//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/02/26.
//

import Foundation

struct BrahmiNumber{
    let arabic:Int
    let brahmi:String
    
    let positional:Bool
    
    init?(number:Int, positional:Bool){
        guard number != 0 else{
            return nil
        }
        
        self.positional=positional
        arabic=number
        
        if positional{
            var positionalString=""
            var multiplier=1
            var parsed=number
            
            while (parsed > 0){
                let div=parsed.quotientAndRemainder(dividingBy: 10)
                positionalString =  (BrahmiNumber.Lookups.brahmiPositionalDict[div.remainder] ?? "") + positionalString
                multiplier *= 10
                parsed /= 10
            }
            
            brahmi = positionalString
        }
        else if number < 10_000{
            let thousands=number.quotientAndRemainder(dividingBy: 1000)
            let hundreds=thousands.remainder.quotientAndRemainder(dividingBy: 100)
            let tens=hundreds.remainder.quotientAndRemainder(dividingBy: 10)
            let onesString=Lookups.onesDict[tens.remainder] ?? ""
            let tensString=Lookups.tensDict[tens.quotient] ?? ""
            
            let hundredString:String
            switch hundreds.quotient{
            case 0:
                hundredString = ""
            case 1:
                hundredString = Lookups.hundertSymbol
            case 2...9:
                let hundredString_ones=Lookups.onesDict[hundreds.quotient] ?? ""
                hundredString = Lookups.hundertSymbol + Lookups.joiner + hundredString_ones
            default:
                hundredString = ""
            }
            
            let thousandString:String
            switch thousands.quotient{
            case 0:
                thousandString = ""
            case 1:
                thousandString = Lookups.thousandSymbol
            case 2...9:
                let thousands_one=Lookups.onesDict[thousands.quotient] ?? ""
                thousandString = Lookups.thousandSymbol + Lookups.joiner + thousands_one
            default:
                thousandString = ""
            }
            
            
            
            brahmi = thousandString + hundredString + tensString + onesString
        }
        else{
            return nil
        }
               
    }
    
    init?(string:String){
                
        switch string{
        case _ where CharacterSet(charactersIn: string).isSubset(of: Lookups.positionalCharacterSet):
            var number=0
            let lookup=Dictionary(uniqueKeysWithValues: zip(Lookups.brahmiPositionalDict.values,Lookups.brahmiPositionalDict.keys))
            var multiplier=1
            for char in string.reversed(){
                guard let n=lookup[String(char)] else{
                    return nil
                }
                number += n*multiplier
                multiplier *= 10
            }
            
            arabic=number
            brahmi=string
            positional=true
            guard arabic > 0, string.isEmpty == false else{
                return nil
            }
            
        case _ where CharacterSet(charactersIn: string).isSubset(of: Lookups.traditionalCharacterSet):
            let lookups=Lookups()
            
            let parser=BrahmiTraditionalParser(string: string, lookups: lookups)
            guard let a=parser.parse() else{
                return nil
            }
            brahmi = string
            arabic=a
            positional=false
        default:
            return nil
        }
        
    }
    
    
    
    
}
