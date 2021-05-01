//
//  RoemischeZahl.swift
//  RoemischeZahl
//
//  Created by Miho on 2021/04/29.
//

import Foundation
import AVFoundation

protocol AlsRoemischeZahl {
    var anzahl: Int {get}
    var dict: [Int:String] {get}
    var römisch: String {get}
    
}

extension AlsRoemischeZahl{
    var römisch : String{
        return self.dict[self.anzahl] ?? ""
    }
}

protocol AlsArabischeZahl{
    var arabisch:Int {get}
    var multiplikator: Int {get}
    var anzahl: Int {get}
}

extension AlsArabischeZahl{
    var arabisch:Int{
        return self.anzahl * multiplikator
    }
}

class RömischeZahl{
    
    struct Einser: AlsRoemischeZahl, AlsArabischeZahl {
        let anzahl:Int
        let multiplikator:Int = 1
        
        let dict=[0:"",
                  1:"I",
                  2:"II",
                  3:"III",
                  4:"IV",
                  5:"V",
                  6:"VI",
                  7:"VII",
                  8:"VIII",
                  9:"IX"
        ]
        
        init(Zahl:Int){
            let zehner = Zahl / 10
            let übrigeEinser = Zahl - 10 * zehner
            anzahl = übrigeEinser / multiplikator
        }
        
        init(römischeZahl:String) {
            switch römischeZahl {
            case _ where römischeZahl.range(of: "VIII", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=8
            case _ where römischeZahl.range(of: "VII", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=7
            case _ where römischeZahl.range(of: "VI", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=6
            case _ where römischeZahl.range(of: "IX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=9
            case _ where römischeZahl.range(of: "IV", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=4
            case _ where römischeZahl.range(of: "III", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=3
            case _ where römischeZahl.range(of: "II", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=2
            case _ where römischeZahl.range(of: "I", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=1
            case _ where römischeZahl.range(of: "V", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=5
            default:
                self.anzahl=0
            }
        }
    }
    
    struct Zehner: AlsRoemischeZahl, AlsArabischeZahl{
        let anzahl:Int
        let multiplikator:Int = 10
        let dict=[0:"",
                  1:"X",
                  2:"XX",
                  3:"XXX",
                  4:"XL",
                  5:"L",
                  6:"LX",
                  7:"LXX",
                  8:"LXXX",
                  9:"XC"
        ]
        
        init(Zahl:Int){
            let hunderter = Zahl / 100
            let übrigeZehner = Zahl - 100 * hunderter
            anzahl = übrigeZehner / multiplikator
        }
        
        init(römischeZahl:String) {
            switch römischeZahl {
            case _ where römischeZahl.range(of: "LXXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=8
            case _ where römischeZahl.range(of: "LXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=7
            case _ where römischeZahl.range(of: "LX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=6
            case _ where römischeZahl.range(of: "XC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=9
            case _ where römischeZahl.range(of: "LX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=4
            case _ where römischeZahl.range(of: "XXX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=3
            case _ where römischeZahl.range(of: "XX", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=2
            case _ where römischeZahl.range(of: "X", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=1
            case _ where römischeZahl.range(of: "L", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=5
            default:
                self.anzahl=0
            }
        }
        
    }
    
    
    struct Hunderter: AlsRoemischeZahl, AlsArabischeZahl {
        let anzahl:Int
        let multiplikator:Int = 100
        
        let dict=[0:"",
                  1:"C",
                  2:"CC",
                  3:"CCC",
                  4:"CD",
                  5:"D",
                  6:"DC",
                  7:"DCC",
                  8:"DCCC",
                  9:"CM"
        ]
        
        
        init(Zahl:Int){
            let tausnder = Zahl / 1000
            let übrigehunderter = Zahl - 1000 * tausnder
            anzahl = übrigehunderter / multiplikator
        }
        
        init(römischeZahl:String) {
            switch römischeZahl {
            case _ where römischeZahl.range(of: "DCCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=8
            case _ where römischeZahl.range(of: "DCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil :
                self.anzahl=7
            case _ where römischeZahl.range(of: "DC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=6
            case _ where römischeZahl.range(of: "CM", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=9
            case _ where römischeZahl.range(of: "CD", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=4
            case _ where römischeZahl.range(of: "CCC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=3
            case _ where römischeZahl.range(of: "CC", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=2
            case _ where römischeZahl.range(of: "C", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=1
            case _ where römischeZahl.range(of: "D", options: [.caseInsensitive, .anchored, .backwards], range: nil, locale: nil) != nil:
                self.anzahl=5
            default:
                self.anzahl=0
            }
        }
    }
    
    
    struct Tausender: AlsArabischeZahl{
        let anzahl:Int
        let multiplikator:Int = 1000
        
        init(Zahl:Int){
            let tausnder = Zahl / multiplikator
            anzahl = tausnder
        }
        
        var römisch : String{
            switch anzahl {
            case 0:
                return ""
            default:
                return Array(repeating: "M", count: anzahl).joined()
            }
        }
        
        init(römischeZahl:String){
            var gefundeneMs=0
            for buchstabe in römischeZahl{
                if buchstabe.lowercased() == "m"{
                    gefundeneMs+=1
                }
                else{
                    anzahl=0
                    return
                }
            }
            anzahl=gefundeneMs
        }
    }
    
    let synthesizer:AVSpeechSynthesizer=AVSpeechSynthesizer()
    
    
    func macheRömischeZahl(aus Zahl:Int)->String?{
        
        guard Zahl > 0 else {
            return nil
        }
        
        let zehner = Zehner(Zahl: Zahl)
        let einser = Einser(Zahl: Zahl)
        let hunderter = Hunderter(Zahl: Zahl)
        let tausender = Tausender(Zahl: Zahl)
        
        let zehnerRömisch = zehner.römisch
        let einserRömisch = einser.römisch
        let hunderterRömisch = hunderter.römisch
        
        return tausender.römisch + hunderterRömisch + zehnerRömisch + einserRömisch
    }
    
    
    func macheZahl(aus römischerZahl:String)->Int?{
        let romischeZahlBuchstaben="iIvVxXlLcCdDmM"
        let buchstabenHaufen=CharacterSet(charactersIn: romischeZahlBuchstaben)
        let vorhandeneBuchstaben=CharacterSet(charactersIn: römischerZahl.trimmingCharacters(in: .whitespaces))
        guard vorhandeneBuchstaben.isSubset(of: buchstabenHaufen) else {
            return nil
        }
        let einser=Einser(römischeZahl: römischerZahl)
        var restZahl=römischerZahl.replacingOccurrences(of: einser.römisch, with: "", options: [.backwards, .caseInsensitive, .anchored], range: nil)
        let zehner=Zehner(römischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehner.römisch, with: "", options: [.backwards, .caseInsensitive, .anchored], range: nil)
        let hunderter=Hunderter(römischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hunderter.römisch, with: "", options: [.backwards, .caseInsensitive, .anchored], range: nil)
        let tausender=Tausender(römischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tausender.römisch, with: "", options: [.backwards, .caseInsensitive, .anchored], range: nil)
        
        if restZahl.count > 0{
            return nil
        }
        
        
        return tausender.arabisch + hunderter.arabisch + zehner.arabisch + einser.arabisch
    }
    
    
    func utterance(input:String, roman:String)->[AVSpeechUtterance]{
        let locale=AVSpeechSynthesisVoice.currentLanguageCode()
        var voice = AVSpeechSynthesisVoice(language: locale)
        if voice == nil{
            let lang=Locale.current.languageCode ?? ""
            voice=AVSpeechSynthesisVoice(language: lang)
        }
        
        let textZumSprechen = String(format: NSLocalizedString("%@ is:", comment: "utterance string"), input)


        let utterance = AVSpeechUtterance(string: String(textZumSprechen))
        utterance.voice=voice
        utterance.rate=0.35
        utterance.postUtteranceDelay=0.7
        let romanUtterances: [AVSpeechUtterance]
        
        if Int(roman) != nil{
            let u=AVSpeechUtterance(string:roman)
            u.voice=voice
            u.rate=0.35
            u.preUtteranceDelay=0.6
            romanUtterances=[u]
        }
        else{
            let textWithSpace=roman.map({String($0)})//.joined(separator: " \n")
            romanUtterances = textWithSpace.map({t->AVSpeechUtterance in
                let u=AVSpeechUtterance(string: t.lowercased())
                u.voice=voice
                u.rate=0.2
                u.preUtteranceDelay=0.6
                u.postUtteranceDelay=0.5
                return u
            })
        }

        


        return [utterance] + romanUtterances
    }
    
    func speak(input:String, roman:String){
        self.utterance(input: input, roman: roman).forEach({u in
            self.synthesizer.speak(u)
        })
    }
    
}
