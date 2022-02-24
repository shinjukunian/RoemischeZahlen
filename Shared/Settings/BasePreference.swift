//
//  BasePreference.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/24.
//

import Foundation
import XLIICore

struct BasePreference: RawRepresentable, Equatable, Hashable, Identifiable{
    
    typealias RawValue = String
    
    let bases:[Int]
    
    var rawValue: String{
        return bases.map({String($0)}).joined(separator: "|")
    }
    
    var id: String{
        rawValue
    }
    
    init(bases:[Int]){
        self.bases=bases
    }
    
    init(outputs: [Output]){
        self.bases=outputs.compactMap({output in
            switch output{
            case .numeric(let base):
                return base
            default:
                return nil
            }
        })
    }
    
    init?(rawValue: String) {
        bases=rawValue.split(separator: "|").compactMap({Int($0)})
    }
    
    static let defaultBases = [2,8,10,16]
    
    static let `default` = BasePreference(bases: BasePreference.defaultBases)
    
    static var preferredBases:BasePreference{
        BasePreference(rawValue: UserDefaults.standard.string(forKey: UserDefaults.Keys.preferredBasesKey) ?? "") ?? .default
    }
    
    var outputs:[Output]  {
        self.bases.map({.numeric(base: $0)})
    }
    
}
