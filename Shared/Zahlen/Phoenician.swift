//
//  Phoenician.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/23.
//

import Foundation

struct PhoenizianFormatter{
    
    let singlesDict:[Int:String] = [0:"",
                                    1:"𐤖",
                                    2:"𐤚",
                                    3:"𐤛",
                                    4:"𐤛𐤖",
                                    5:"𐤛𐤚",
                                    6:"𐤛𐤛",
                                    7:"𐤛𐤛𐤖",
                                    8:"𐤛𐤛𐤚",
                                    9:"𐤛𐤛𐤛"
    ]
    
    static let hundredSymbol = "𐤙"
    static let tenSymbol = "𐤗"
    static let twentySymbol = "𐤘"
    
    let arabic:Int
    
    let phoenician:String
    
    init?(number:Int){
        guard (1..<1000).contains(number) else{
            return nil
        }
        self.arabic=number
        
        
        let hundreds=number.quotientAndRemainder(dividingBy: 100)
        let twenties=hundreds.remainder.quotientAndRemainder(dividingBy: 20)
        let tens=twenties.remainder.quotientAndRemainder(dividingBy: 10)
        let ones=tens.remainder
        
        let onesString = singlesDict[ones] ?? ""
        let tensString=Array(repeating: PhoenizianFormatter.tenSymbol, count: tens.quotient).joined()
        let twentiesString=Array(repeating: PhoenizianFormatter.twentySymbol, count: twenties.quotient).joined()
        let hundredsString="\(hundreds.quotient > 1 ? (singlesDict[hundreds.quotient] ?? "") : "")\(hundreds.quotient > 0 ? PhoenizianFormatter.hundredSymbol: "")"
        
        let phoenician=[onesString,tensString,twentiesString,hundredsString].reversed().joined()
        self.phoenician=phoenician
    }
    
    
    init?(string:String){
        guard string.potentiellePhoenizischeZahl else{
            return nil
        }
        
        self.phoenician=string
        
        let singlesLookup=singlesDict.sorted(by: {$0.0 > $1.0})
        
        let ones=singlesLookup.first(where: {_, n in
            string.range(of: n, options: [.anchored,.backwards], range: string.startIndex..<string.endIndex, locale: nil) != nil
        })?.key ?? 0
        
        let tens=string.contains(PhoenizianFormatter.tenSymbol) ? 1 : 0
        
        let twenties=string.filter({char in
            String(char) == PhoenizianFormatter.twentySymbol
        }).count
        
        let hundreds = {()->Int in
            if let r=string.range(of: PhoenizianFormatter.hundredSymbol){
                let toEnd=string.startIndex..<r.upperBound
                let hundredsString=String(string[toEnd])
                let ones=singlesLookup.first(where: {_, n in
                    hundredsString.range(of: n, options: [.anchored], range: hundredsString.startIndex..<hundredsString.endIndex, locale: nil) != nil
                })?.key ?? 1
                return ones
            }
            return 0
        }()
        
        
        self.arabic=ones + 10 * tens + 20 * twenties + hundreds * 100
    }
    
}
