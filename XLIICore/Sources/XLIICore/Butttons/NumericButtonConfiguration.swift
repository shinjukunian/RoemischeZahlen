//
//  NumericButtonConfiguration.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import Foundation


struct NumericButtonConfiguration: ButtonProviding{
    let buttonValues:[[String]]
    let values:[[Int]]
    
    init(base:Int){
        let possibleValues=["0","1","2","3","4","5","6","7","8","9","A","B","C","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        let usedValues=possibleValues.prefix(base)
        let maxPerRow=[4,5].sorted(by: {n1,n2 in
            let remainder1=usedValues.count.quotientAndRemainder(dividingBy: n1).remainder
            let remainder2=usedValues.count.quotientAndRemainder(dividingBy: n2).remainder
            if remainder1 == remainder2{
                return n1 > n2
            } else{
                return remainder1 < remainder2
            }
        }).first ?? 5
        
        var buttonValues=[[String]]()
        var values=[[Int]]()
//            var added=0
        let rowStride=stride(from: 0, to: usedValues.count, by: maxPerRow)
        for rowIDX in rowStride{
            let rowEnd=(rowIDX+maxPerRow > usedValues.count) ? usedValues.count : rowIDX+maxPerRow
            let rowEntries=usedValues[rowIDX..<rowEnd]
            buttonValues.append(Array(rowEntries))
            let rowValues=(rowIDX..<rowEnd).map({$0})
            values.append(rowValues)
        }
        self.buttonValues=buttonValues
        self.values=values
    }
}
