//
//  SundaneseButtonConfiguration.swift
//  
//
//  Created by Morten Bertz on 2022/03/08.
//

import Foundation

struct SundaneseButtonConfiguration: ButtonProviding{
    
    let table = [0:"᮰",
                 1:"᮱",
                 2:"᮲",
                 3:"᮳",
                 4:"᮴",
                 5:"᮵",
                 6:"᮶",
                 7:"᮷",
                 8:"᮸",
                 9:"᮹"]
    
    let seperator = "|"
    
    let values: [[Int]]
    
    var buttonValues: [[String]]
    
    var formattingHandler: (String) -> String = {s in return s}
    
    init(){
        buttonValues = [["᮷","᮸","᮹"],["᮴","᮵","᮶"],["᮱","᮲","᮳"],["᮰"]]
        values=[[7,8,9],[4,5,6],[1,2,3],[0]]
        self.formattingHandler = parseInput(_:)
    }
    
    func parseInput(_ string:String)->String{
        guard string.isEmpty == false else{
            return string
        }
        return seperator + string.filter({String($0) != seperator}) + seperator
    }
}

