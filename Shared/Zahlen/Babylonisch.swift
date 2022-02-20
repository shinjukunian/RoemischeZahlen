//
//  Sechziger.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import Foundation

struct BabylonischeZehner:AlsBabylonischeZahl{
    let anzahl:Int
    let multiplikator:Int = 10
    
    let arabischBabylonischDict: [Int : String] = [0:"",
                                                   1:"𒌋",
                                                   2:"《",
                                                   3:"𒌍",
                                                   4:"𒐏",
                                                   5:"𒐐",
    ]
    
    init(Zahl:Int){
        let sechziger = Zahl / 60
        let ubrigeZehner = Zahl - 60 * sechziger
        anzahl = ubrigeZehner / multiplikator
    }
}



struct Sechziger:AlsBabylonischeZahl{
    
    let anzahl:Int
    let multiplikator:Int = 60
    
    let arabischBabylonischDict: [Int : String] = [0:"␣",
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
    
    init(Zahl:Int){
        let dreitausendSechsHunderter = Zahl / 600
        let ubrigeSechziger = Zahl - 600 * dreitausendSechsHunderter
        anzahl = ubrigeSechziger / multiplikator
    }
}

struct Sechshunderter: AlsBabylonischeZahl{
    let anzahl:Int
    let multiplikator:Int = 600
    
    let arabischBabylonischDict: [Int : String] = [0:"",
                                                   1:"𒌋",
                                                   2:"《",
                                                   3:"𒌍",
                                                   4:"𒐏",
                                                   5:"𒐐",
    ]
    
    init(Zahl:Int){
        let dreitausendSechsHunderter = Zahl / 3600
        let ubrigeSechziger = Zahl - 3600 * dreitausendSechsHunderter
        anzahl = ubrigeSechziger / multiplikator
    }
}


struct DreitausendSechshunderter:AlsBabylonischeZahl{
    
    let anzahl:Int
    let multiplikator:Int = 3600
    
    let arabischBabylonischDict: [Int : String] = [0:"␣",
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
    
    init(Zahl:Int){
        let larger = Zahl / (3600*10)
        let remainder = Zahl - (3600*10) * larger
        anzahl = remainder / multiplikator
    }
}

struct Sechsunddreissigtausender:AlsBabylonischeZahl{
    
    let anzahl:Int
    let multiplikator:Int = 36000
    
    let arabischBabylonischDict: [Int : String] = [0:"",
                                                   1:"𒌋",
                                                   2:"《",
                                                   3:"𒌍",
                                                   4:"𒐏",
                                                   5:"𒐐",
    ]
    
    init(Zahl:Int){
        let larger = Zahl / (3600*60)
        let remainder = Zahl - (3600*60) * larger
        anzahl = remainder / multiplikator
    }
}
