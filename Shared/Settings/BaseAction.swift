//
//  BaseAction.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/24.
//

import Foundation

enum BaseAction:Identifiable,Equatable,Hashable, Comparable{
    typealias ID = String
    case display(base:Int)
    case insert(base:Int)
    
    var id: String{
        switch self {
        case .display(let base):
            return "display \(base)"
        case .insert(let base):
            return "insert \(base)"
        }
    }
    static func < (lhs: BaseAction, rhs: BaseAction) -> Bool {
        switch (lhs,rhs){
        case (.display(let b1), .display(let b2)):
            return b1 < b2
        case (.insert(let b1), .insert(let b2)):
            return b1 < b2
        case (.display(_), .insert(_)):
            return true
        default:
            return false
        }
    }
}
