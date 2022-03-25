//
//  NumericParsingResult.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/24.
//

import Foundation
import XLIICore

struct NumericParsingResult: Equatable,Hashable,Identifiable{
    var id: String{
        return "\(value)_forText\(originalText)"
    }
    
    let originalText:String
    
    let value:Int
    
    let type:Output
    
    static let empty = NumericParsingResult(originalText: "", value: 0, type: .currentLocale)
}

struct NumericParser{
    let text:String
    let representations:[NumericParsingResult]
    
    init?(text:String, bases:[Int]){
        self.text=text
        let results=bases.compactMap({base->NumericParsingResult? in
            if let int=Int(text, radix: base){
                return NumericParsingResult(originalText: text, value: int, type: .numeric(base: base))
            }
            else{
                return nil
            }
        })
        guard results.isEmpty == false else{
            return nil
        }
        representations=results
    }
}

enum InputType: Equatable,Hashable{
    case valid
    case invalid
    case empty
    case overflow
}


extension Output{
    var isDecimal: Bool{
        switch self {
        case .arabisch:
            return true
        case .numeric(let base) where base == 10:
            return true
        default: return false
        }
    }
    
}


