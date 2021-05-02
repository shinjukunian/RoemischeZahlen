//
//  String+Extensions.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation

extension String{
    var potenzielleRömischeZahl:Bool{
        let romischerBuchstabenHaufen=CharacterSet(charactersIn: "iIvVxXlLcCdDmM")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: romischerBuchstabenHaufen)
    }
    
    var potenzielleJapanischeZahl:Bool{
        let japanischeZahlenBuchstabenHaufen=CharacterSet(charactersIn: "一二三四五六七八九十百千万億")
        let vorhandeneBuchstaben=CharacterSet(charactersIn: self.trimmingCharacters(in: .whitespaces))
        return vorhandeneBuchstaben.isSubset(of: japanischeZahlenBuchstabenHaufen)
    }
}
