//
//  RoemischeZahl.swift
//  RoemischeZahl
//
//  Created by Miho on 2021/04/29.
//

import Foundation
import AVFoundation

class RömischeZahl{
    
    let synthesizer:AVSpeechSynthesizer=AVSpeechSynthesizer()
    
    func macheRömischeZahl(aus Zahl:Int)->String{
        
        guard Zahl > 0 else {
            return ""
        }
        
        struct Zehner{
            let anzahl:Int
            
            init(Zahl:Int){
                let hunderter = Zahl / 100
                let übrigeZehner = Zahl - 100 * hunderter
                anzahl = übrigeZehner / 10
            }
            
            var römisch : String{
                switch anzahl {
                case 0:
                    return ""
                case 1:
                    return "X"
                case 2:
                    return "XX"
                case 3:
                    return "XXX"
                case 4:
                    return "XL"
                case 5:
                    return "L"
                case 6:
                    return "LX"
                case 7:
                    return "LXX"
                case 8:
                    return "LXXX"
                case 9:
                    return "XC"
                default:
                    fatalError()
                }
            }
            
        }
        
        struct Einser {
            let anzahl:Int
            
            init(Zahl:Int){
                let zehner = Zahl / 10
                let übrigeEinser = Zahl - 10 * zehner
                anzahl = übrigeEinser
            }
            
            var römisch : String{
                switch anzahl {
                case 0:
                    return ""
                case 1:
                    return "I"
                case 2:
                    return "II"
                case 3:
                    return "III"
                case 4:
                    return "IV"
                case 5:
                    return "V"
                case 6:
                    return "VI"
                case 7:
                    return "VII"
                case 8:
                    return "VIII"
                case 9:
                    return "IX"
                default:
                    fatalError()
                }
            }
            
        }
        
        
        struct Hunderter {
            let anzahl:Int
            
            init(Zahl:Int){
                let tausnder = Zahl / 1000
                let übrigehunderter = Zahl - 1000 * tausnder
                anzahl = übrigehunderter / 100
            }
            
            var römisch : String{
                switch anzahl {
                case 0:
                    return ""
                case 1:
                    return "C"
                case 2:
                    return "CC"
                case 3:
                    return "CCC"
                case 4:
                    return "CD"
                case 5:
                    return "D"
                case 6:
                    return "DC"
                case 7:
                    return "DCC"
                case 8:
                    return "DCCC"
                case 9:
                    return "CM"
                default:
                    fatalError()
                }
            }
            
        }
        
        
        struct Tausender{
            let anzahl:Int
            
            init(Zahl:Int){
                let tausnder = Zahl / 1000
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
    
    func utterance(input:String, roman:String)->[AVSpeechUtterance]{
        let locale=AVSpeechSynthesisVoice.currentLanguageCode()
        var voice = AVSpeechSynthesisVoice(language: locale)
        if voice == nil{
            let lang=Locale.current.languageCode ?? ""
            voice=AVSpeechSynthesisVoice(language: lang)
        }

        let textWithSpace=roman.map({String($0)})//.joined(separator: " \n")

        let textZumSprechen = String(format: NSLocalizedString("%@ is:", comment: "utterance string"), input)


        let utterance = AVSpeechUtterance(string: String(textZumSprechen))
        utterance.voice=voice
        utterance.rate=0.35
        utterance.postUtteranceDelay=0.7

        let romanUtterances = textWithSpace.map({t->AVSpeechUtterance in
            let u=AVSpeechUtterance(string: t.lowercased())
            u.voice=voice
            u.rate=0.2
            u.preUtteranceDelay=0.6
            u.postUtteranceDelay=0.5
            return u
        })


        return [utterance] + romanUtterances
    }
    
    func speak(input:String, roman:String){
        self.utterance(input: input, roman: roman).forEach({u in
            self.synthesizer.speak(u)
        })
    }
    
}
