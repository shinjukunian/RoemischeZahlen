//
//  Geez.swift
//  
//
//  Created by Morten Bertz on 2022/02/28.
//

import Foundation

//https://www.metaappz.com/Geez_Numbers_Converter/Default.aspx#NUMBER

struct GeezNumber{
    let arabic:Int
    let geez:String

    init?(number:Int){
        guard number > 0 else{
            return nil
        }
        self.arabic=number
        
        var parsed=number
        var multiplier=1
        var components = [String]()
        
        while (parsed > 0){
            let div10_000=parsed.quotientAndRemainder(dividingBy: 10_000)
            let div100=div10_000.remainder.quotientAndRemainder(dividingBy: 100)
            let div100_ones=div100.quotient.quotientAndRemainder(dividingBy: 10)
            let div10=div100.remainder.quotientAndRemainder(dividingBy: 10)
            
            let onesString=GeezNumber.table[div10.remainder]

            
            let tensString=GeezNumber.table[div10.quotient * 10]
            
            let hundredString=[GeezNumber.table[div100_ones.quotient * 10],
                               GeezNumber.table[div100.quotient > 1 ? div100_ones.remainder : 0],
                               GeezNumber.table[div100.quotient > 0 ? 100 : 0]].compactMap({$0}).joined()
            
            let text=[hundredString,tensString,onesString].compactMap({$0}).joined() + (multiplier > 1 ? GeezNumber.table[10_000]! : "")
            
            components.append(text)
            parsed = div10_000.quotient
            multiplier *= 10_000
        }
        
        let text=components.reversed().joined()
        if text.count > 1{
            geez = String(text.drop(while: {String($0) == GeezNumber.table[1]!}))
        }
        else{
            geez = text
        }
    }
    
    init?(string:String){
        guard string.isEmpty == false else{
            return nil
        }
        self.geez=string
        
        let hundredsCharacter=GeezNumber.table[100]!
        let tenThousandsCharacter=GeezNumber.table[10_000]!
        let reverseLookup=Dictionary(uniqueKeysWithValues: zip(GeezNumber.table.values, GeezNumber.table.keys))
        
        func parseTens(_ tens:String)->Int{
            var number=0
            for char in tens{
                if let match = reverseLookup[String(char)]{
                    number += match
                }
            }
            return number
        }
        
        func parseHundreds(_ hundreds:String)->Int{
            var number=0
            if let hundredsRange=hundreds.range(of: hundredsCharacter){
                let hundredsMultiplier=hundreds[hundreds.startIndex..<hundredsRange.lowerBound]
                let tens=hundreds[hundredsRange.upperBound..<hundreds.endIndex]
                if hundredsMultiplier.isEmpty{
                    number += 100
                }
                else{
                    number += parseTens(String(hundredsMultiplier)) * 100
                }
                number += parseTens(String(tens))
            }
            else{
                number = parseTens(hundreds)
            }
            
            
            return number
        }
        
        var parsed = string
        var multiplier=1
        var number=0
        
        while(parsed.isEmpty == false){
            if let sub10_000 = parsed.range(of: tenThousandsCharacter, options: [.backwards]){
                let hundredsString = String(parsed[sub10_000.upperBound..<parsed.endIndex])
                number += parseHundreds(hundredsString) * multiplier
                if sub10_000.lowerBound == parsed.startIndex{
                    number += 10000 * multiplier
                }
                parsed = String(parsed[parsed.startIndex..<sub10_000.lowerBound])
                multiplier *= 10_000
            }
            else{
                number += parseHundreds(parsed) * multiplier
                parsed.removeAll()
            }
            
        }
        self.arabic=number
    }
    
    
    
}

extension GeezNumber{
    static let table = [1:"፩",
                        2:"፪",
                        3:"፫",
                        4:"፬",
                        5:"፭",
                        6:"፮",
                        7:"፯",
                        8:"፰",
                        9:"፱",
                        10:"፲",
                        20:"፳",
                        30:"፴",
                        40:"፵",
                        50:"፶",
                        60:"፷",
                        70:"፸",
                        80:"፹",
                        90:"፺",
                        100:"፻",
                        10_000:"፼"
    ]
}
