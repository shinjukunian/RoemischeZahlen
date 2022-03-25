//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import Foundation

protocol Cyrillic{
    init?(number:Int)
    var arabic:Int {get}
    var cyrillic:String {get}
    var cyrilicUsingTitlo:String {get}
}

struct CyrilligLargeNumber: Cyrillic{
    let arabic:Int
    let cyrillic:String
    
    init?(number:Int){
        
        guard number < Int64(10_000_000_000) else{
            return nil
        }
        
        self.arabic=number
        
        var parsed = number
        var multiplier=1
        var components = [String]()
        
        let decades = [1:["","",""], 1000:[CyrillicNumber.thousandsSymbol, CyrillicNumber.tenThousandSymbol, CyrillicNumber.hundredThousandSymbol], 1_000_000:[CyrillicNumber.millionSymbol, CyrillicNumber.tenMillionSymbol,CyrillicNumber.hundredMillionSymbol], 1_000_000_000:[CyrillicNumber.billionSymbol,"",""]]
        
        while(parsed > 0){
            
            guard let multiplierCharacters=decades[multiplier] else{
                return nil
            }
            let pureHundreds=parsed.quotientAndRemainder(dividingBy: 1000).remainder
            let hundreds=pureHundreds.quotientAndRemainder(dividingBy: 100)
            let hundredsStrings=CyrillicNumber.table[hundreds.quotient * (multiplier == 1 ? 100 : 1)]
            
            let tensString:String?
            let onesString:String?
            
            if (11...19).contains(hundreds.remainder),
                multiplier == 1{
                tensString=CyrillicNumber.table[hundreds.remainder]
                onesString=nil
            }
            else{
                let tens=hundreds.remainder.quotientAndRemainder(dividingBy: 10)
                tensString=CyrillicNumber.table[tens.quotient * (multiplier == 1 ? 10: 1)]
                onesString=CyrillicNumber.table[tens.remainder]
            }
            parsed /= 1000
            multiplier *= 1000
            let decadeComponents = zip(multiplierCharacters.reversed(), [hundredsStrings,tensString,onesString])
                .compactMap({character, item -> String? in
                    if let item=item,
                        item.isEmpty == false{
                        if character == CyrillicNumber.thousandsSymbol{
                            return  character + item
                        }
                        else{
                            return item + character
                        }
                        
                    }
                    return nil
                })
                
            let text=decadeComponents.joined()
            components.append(text)
        }
        
        let text=components.reversed().joined()
        cyrillic=text
    }
}



extension CyrilligLargeNumber{
    static var largeNumbersLookup:[String:Int] {
        let symbols = [10_000:CyrillicNumber.tenThousandSymbol,
                       100_000:CyrillicNumber.hundredThousandSymbol,
                       1_000_000:CyrillicNumber.millionSymbol,
                       10_000_000:CyrillicNumber.tenMillionSymbol,
                       100_000_000:CyrillicNumber.hundredMillionSymbol,
                       1_000_000_000:CyrillicNumber.billionSymbol]
        
        let numericSymbols=symbols.map({value, symbol -> [(String,Int)] in
            
            let range=(1...9)
            let symbols=range.map({multiplier -> (String,Int) in
                let numberSymbol=CyrillicNumber.table[multiplier]! //should always exist
                return (numberSymbol + symbol, multiplier * value)
                
            })
            return symbols
        }).flatMap({$0})
        let lookup=Dictionary(uniqueKeysWithValues: numericSymbols)
        return lookup
    }
}
