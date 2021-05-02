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
    let romischerBuchstabenHaufen=CharacterSet(charactersIn: "iIvVxXlLcCdDmM")
    let japanischeZahlenBuchstabenHaufen=CharacterSet(charactersIn: "一二三四五六七八九十百千万億")
    
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
    
    func macheJapanischeZahl(aus Zahl:Int)->String?{
        guard Zahl > 0 else {
            return nil
        }
        let z:[AlsJapanischeZahl]=[HundertMillionen(Zahl: Zahl), ZehnTausender(Zahl: Zahl), JapanischeTaussender(Zahl: Zahl), Hunderter(Zahl: Zahl), Zehner(Zahl: Zahl),Einser(Zahl: Zahl)]
        return z.reduce("", {r, z in
            r+z.japanisch
        })
    }
    
    
    
    func macheZahl(aus text:String)->Int?{

        let vorhandeneBuchstaben=CharacterSet(charactersIn: text.trimmingCharacters(in: .whitespaces))
        switch vorhandeneBuchstaben {
        case _ where vorhandeneBuchstaben.isSubset(of: romischerBuchstabenHaufen):
            return self.macheZahl(römisch: text)
        case _ where vorhandeneBuchstaben.isSubset(of: japanischeZahlenBuchstabenHaufen):
            return self.macheZahl(japanisch: text)
        default:
            return nil
        }
    }
    
    func macheZahl(römisch Zahl:String)->Int?{
        let einser=Einser(römischeZahl: Zahl)
        var restZahl=Zahl.replacingOccurrences(of: einser.römisch, with: "", options: [.backwards, .caseInsensitive, .anchored], range: nil)
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
    
    fileprivate func macheZahl(japanisch Zahl:String)->Int?{
        let einser=Einser(japanischeZahl: Zahl)
        var restZahl=Zahl.replacingOccurrences(of: einser.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let zehner=Zehner(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehner.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let hunderter=Hunderter(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hunderter.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let tausender=JapanischeTaussender(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tausender.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        
        if restZahl.count > 0{
            return nil
        }
        
        
        return tausender.arabisch + hunderter.arabisch + zehner.arabisch + einser.arabisch
    }
    
    
    func utterance(input:String, output:String, format:Output)->[AVSpeechUtterance]{
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
        let outputUtterances: [AVSpeechUtterance]
        
        switch format {
        case .römisch:
            let textWithSpace=output.map({String($0)})//.joined(separator: " \n")
            outputUtterances = textWithSpace.map({t->AVSpeechUtterance in
                let u=AVSpeechUtterance(string: t.lowercased())
                u.voice=voice
                u.rate=0.2
                u.preUtteranceDelay=0.6
                u.postUtteranceDelay=0.5
                return u
            })
        case .arabisch:
            let u=AVSpeechUtterance(string:output)
            u.voice=voice
            u.rate=0.35
            u.preUtteranceDelay=0.6
            outputUtterances=[u]
        case .japanisch:
            let japanischeStimme=AVSpeechSynthesisVoice(language: "ja")
            let u=AVSpeechUtterance(string:output)
            u.voice=japanischeStimme
            u.rate=0.35
            u.preUtteranceDelay=0.6
            outputUtterances=[u]
        }
    
        return [utterance] + outputUtterances
    }
    
    func speak(input:String, output:String, format:Output){
        self.utterance(input: input, output: output, format: format).forEach({u in
            self.synthesizer.speak(u)
        })
    }
    
}
