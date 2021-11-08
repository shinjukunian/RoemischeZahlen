//
//  RoemischeZahl.swift
//  RoemischeZahl
//
//  Created by Miho on 2021/04/29.
//

import Foundation
import AVFoundation

extension Output{
    var voice:AVSpeechSynthesisVoice?{
        switch self {
        case .japanisch:
            return AVSpeechSynthesisVoice(language: "ja")
        default:
            let locale=AVSpeechSynthesisVoice.currentLanguageCode()
            var voice = AVSpeechSynthesisVoice(language: locale)
            if voice == nil{
                let lang=Locale.current.languageCode ?? ""
                voice=AVSpeechSynthesisVoice(language: lang)
            }
            return voice
        }
    }
    
    
}


struct SpeechOutput{
    let format:Output
    let text:String
    
    init(text: String, format:Output) {
        self.text=text
        self.format=format
    }
    
    init(text:String) {
        switch text {
        case _ where text.potenzielleRömischeZahl:
            self.format = .römisch
        case _ where text.potenzielleJapanischeZahl:
            self.format = .japanisch
        case _ where Int(text) != nil:
            self.format = .arabisch
        default:
            self.format = .arabisch
        }
        
        self.text=text
    }
    
    var utterances:[AVSpeechUtterance]{
        let outputUtterances: [AVSpeechUtterance]
        
        switch self.format {
        case .römisch:
            let textWithSpace=self.text.map({String($0)})
            outputUtterances = textWithSpace.map({t->AVSpeechUtterance in
                let u=AVSpeechUtterance(string: t.lowercased())
                u.voice=self.format.voice
                u.rate=0.3
                u.preUtteranceDelay=0.2
                u.postUtteranceDelay=0
                return u
            })
        case .arabisch:
            let u=AVSpeechUtterance(string:self.text)
            u.voice=self.format.voice
            u.rate=0.35
            u.preUtteranceDelay=0.6
            outputUtterances=[u]
        case .japanisch, .japanisch_bank:
            let u=AVSpeechUtterance(string:self.text)
            u.voice=self.format.voice
            u.rate=0.35
            u.preUtteranceDelay=0.6
            outputUtterances=[u]
        }
        return outputUtterances
    }
    
}

class ExotischeZahlenFormatter{
    
    lazy var synthesizer:AVSpeechSynthesizer=AVSpeechSynthesizer()
    
    func macheRömischeZahl(aus Zahl:Int)->String?{
        
        guard Zahl > 0, Zahl < 1_000_000_000 else {
            return nil
        }
        
        let zehner = Zehner(Zahl: Zahl)
        let einser = Einer(Zahl: Zahl)
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
        let z:[AlsJapanischeZahl]=[HundertMillionen(Zahl: Zahl), ZehnTausender(Zahl: Zahl), JapanischeTausender(Zahl: Zahl), Hunderter(Zahl: Zahl), Zehner(Zahl: Zahl),Einer(Zahl: Zahl)]
        return z.reduce("", {r, z in
            r+z.japanisch
        })
    }
    
    func macheJapanischeBankZahl(aus Zahl:Int, einfach:Bool)->String?{
        guard Zahl > 0, Zahl < 100_000_000 else {
            return nil
        }
        let z:[AlsJapanischeBankZahl]=[ZehnTausender(Zahl: Zahl),
                                       JapanischeTausender(Zahl: Zahl),
                                       Hunderter(Zahl: Zahl),
                                       Zehner(Zahl: Zahl),
                                       Einer(Zahl: Zahl)]
        if einfach{
            return z.reduce("", {r, z in
                r+z.japanisch_Bank_einfach
            })
        }
        else{
            return z.reduce("", {r, z in
                r+z.japanisch_Bank
            })
        }
        
       
    }
    
    
    
    func macheZahl(aus text:String)->Int?{

        switch text {
        case _ where text.potenzielleRömischeZahl:
            return self.macheZahl(römisch: text)
        case _ where text.potenzielleJapanischeZahl:
            return self.macheZahl(japanisch: text)
        default:
            return nil
        }
    }
    
    func macheZahl(römisch Zahl:String)->Int?{
        let einser=Einer(römischeZahl: Zahl)
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
        let einser=Einer(japanischeZahl: Zahl)
        var restZahl=Zahl.replacingOccurrences(of: einser.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        restZahl=restZahl.replacingOccurrences(of: einser.japanisch_Bank, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let zehner=Zehner(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehner.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        restZahl=restZahl.replacingOccurrences(of: zehner.japanisch_Bank, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let hunderter=Hunderter(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hunderter.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        restZahl=restZahl.replacingOccurrences(of: hunderter.japanisch_Bank, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let tausender=JapanischeTausender(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tausender.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        restZahl=restZahl.replacingOccurrences(of: tausender.japanisch_Bank, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let zehnTausender=ZehnTausender(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: zehnTausender.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        restZahl=restZahl.replacingOccurrences(of: zehnTausender.japanisch_Bank, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        let hundertMillionen=HundertMillionen(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: hundertMillionen.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        
        if restZahl.count > 0{
            return nil
        }
        
        
        return hundertMillionen.arabisch + zehnTausender.arabisch + tausender.arabisch + hunderter.arabisch + zehner.arabisch + einser.arabisch
    }
    
    
    func utterance(input:SpeechOutput, output:SpeechOutput)->[AVSpeechUtterance]{
        
        
        let textZumSprechen=NSLocalizedString("is:", comment: "utterance string")
        let u2 = AVSpeechUtterance(string: String(textZumSprechen))
        u2.voice=Output.arabisch.voice
        u2.rate=AVSpeechUtteranceDefaultSpeechRate
        u2.postUtteranceDelay=0.1
        
        return input.utterances + [u2] + output.utterances
    }
    
    func speak(input:SpeechOutput, output:SpeechOutput){
        self.synthesizer.stopSpeaking(at: .immediate)
        
        self.utterance(input: input, output: output).forEach({u in
            self.synthesizer.speak(u)
        })
    }
    
}
