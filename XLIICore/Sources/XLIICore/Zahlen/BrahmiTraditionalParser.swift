//
//  BrahmiTraditionalParser.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import Foundation

struct BrahmiTraditionalParser{
    
    let string:String
    let lookups:BrahmiNumber.Lookups
    
    init(string:String, lookups:BrahmiNumber.Lookups) {
        self.string=string
        self.lookups=lookups
    }
    
    func parse()->Int?{
        guard string.isEmpty == false else{
            return nil
        }
        
        let combined=lookups.combined
        
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
        
        return number
    }
    
}

extension BrahmiNumber{
    struct Lookups{
        
        static let brahmiPositionalDict = [0:"𑁦",1:"𑁧",2:"𑁨",3:"𑁩",4:"𑁪",5:"𑁫",6:"𑁬",7:"𑁭",8:"𑁮",9:"𑁯"]
        static let onesDict = [0:"",
                       1:"𑁒",
                       2:"𑁓",
                       3:"𑁔",
                       4:"𑁕",
                       5:"𑁖",
                       6:"𑁗",
                       7:"𑁘",
                       8:"𑁙",
                       9:"𑁚"
        ]
        
        static let tensDict = [0:"",
                        1:"𑁛",
                        2:"𑁜",
                        3:"𑁝",
                        4:"𑁞",
                        5:"𑁟",
                        6:"𑁠",
                        7:"𑁡",
                        8:"𑁢",
                        9:"𑁣"
        ]
        
        static let hundertSymbol = "𑁤"
        static let thousandSymbol = "𑁥"
        static let joiner=String(Unicode.Scalar.init(0x1107F)!)
        
        static let traditionalCharacterSet = { () -> CharacterSet in
            let range=Unicode.Scalar.init(0x11052)!...Unicode.Scalar.init(0x11065)!
            var characterSet = CharacterSet(charactersIn: range)
            characterSet.insert(Unicode.Scalar.init(0x1107F)!)
            return characterSet
        }()
        
        static let positionalCharacterSet = CharacterSet(charactersIn: Unicode.Scalar.init(0x11066)!...Unicode.Scalar.init(0x1106F)!)
        
        let thousands:[String:Int]
        let hundreds:[String:Int]
        let tens:[String:Int]
        let ones:[String:Int]
        
        init(){
            ones=Dictionary(uniqueKeysWithValues: zip(Lookups.onesDict.values,Lookups.onesDict.keys))
            tens=Dictionary(uniqueKeysWithValues: zip(Lookups.tensDict.values,Lookups.tensDict.keys))
            
            let symbols100=ones.map({key, val -> (String,Int) in
                switch val{
                case 0:
                    return ("",val)
                case 1:
                    return (Lookups.hundertSymbol,val)
                default:
                    return (Lookups.hundertSymbol+Lookups.joiner+key,val)
                }
            })
            
            hundreds=Dictionary(uniqueKeysWithValues: symbols100)
            let symbols1000=ones.map({key, val -> (String,Int) in
                switch val{
                case 0:
                    return ("",val)
                case 1:
                    return (Lookups.thousandSymbol,val)
                default:
                    return (Lookups.thousandSymbol+Lookups.joiner+key,val)
                }
            })
            thousands=Dictionary(uniqueKeysWithValues: symbols1000)
        }
        
        var combined:[String:Int]{
            let dicts=[ones,tens.mapValues({$0 * 10}),hundreds.mapValues({$0 * 100}),thousands.mapValues({$0 * 1000})]
            return Dictionary(zip(dicts.flatMap({$0.keys}), dicts.flatMap({$0.values})), uniquingKeysWith: {$1})
            
        }
        
    }
}
