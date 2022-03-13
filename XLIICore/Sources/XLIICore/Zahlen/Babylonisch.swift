//
//  Sechziger.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation

struct BabylonischeZahl{
    let arabisch:Int
    let babylonisch:String
    
    let arabischBabylonischDict_ones: [Int : String] = [0:"␣",
                                                   1:"𒐕",
                                                   2:"𒐖",
                                                   3:"𒐗",
                                                   4:"𒐘",
                                                   5:"𒐙",
                                                   6:"𒐚",
                                                   7:"𒐛",
                                                   8:"𒐜",
                                                   9:"𒐝"
    ]
    
    let arabischBabylonischDict_tens: [Int : String] = [0:"",
                                                   1:"𒌋",
                                                   2:"《",
                                                   3:"𒌍",
                                                   4:"𒐏",
                                                   5:"𒐐",
    ]
    
    init?(Zahl:Int){
        
        guard Zahl != 0 else{
            return nil
        }
        
        self.arabisch=Zahl
        
        let multiplicator=60
        var babylonisch = [String]()
        var number=Zahl
        
        while (number > 0){
            let div=number.quotientAndRemainder(dividingBy: multiplicator)
            let remainder=div.remainder
            
            let decimalFraction=(remainder).quotientAndRemainder(dividingBy: 10)
            let ones=arabischBabylonischDict_ones[decimalFraction.remainder] ?? ""
            let tens=arabischBabylonischDict_tens[decimalFraction.quotient] ?? ""
            let text = tens + ones
            babylonisch.append(text)
            
            number /= multiplicator
            
        }
        
        self.babylonisch=babylonisch.reversed().joined(separator: " ")
    }
}
