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
        case .localized(let locale):
            if let language=locale.languageCode{
                return AVSpeechSynthesisVoice(language: language)
            }
            else{
                return nil
            }
            
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
    
    
    var utterances:[AVSpeechUtterance]{
        let outputUtterances: [AVSpeechUtterance]
        
        switch self.format {
        case .römisch, .numeric(_):
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
        case .japanisch, .japanisch_bank, .localized(_):
            let u=AVSpeechUtterance(string:self.text)
            u.voice=self.format.voice
            u.rate=0.35
            u.preUtteranceDelay=0.6
            outputUtterances=[u]
        case .babylonian, .aegean, .sangi, .hieroglyph, .suzhou, .phoenician:
            outputUtterances = [AVSpeechUtterance]()
        }
        return outputUtterances
    }
    
}

class ExotischeZahlenFormatter{
    
    struct NumericalOutput{
        
        enum InputLocale{
            case roman
            case japanese
            case suzhou
            case hieroglyph
            case aegean
            case phoenician
        }
        
        let value:Int
        let locale:InputLocale
    }
    
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
        
        switch Zahl{
        case ..<0:
            return nil
        case 0:
            return "〇"
        case 0...:
            let z:[AlsJapanischeZahl]=[TenQuadrillion(Zahl: Zahl),
                                       OneTrillion(Zahl: Zahl),
                                       HundertMillionen(Zahl: Zahl),
                                       ZehnTausender(Zahl: Zahl),
                                       JapanischeTausender(Zahl: Zahl),
                                       Hunderter(Zahl: Zahl),
                                       Zehner(Zahl: Zahl),
                                       Einer(Zahl: Zahl)]
            return z.reduce("", {r, z in
                r+z.japanisch
            })
        default:
            return nil
        }
        
        
    }
    
    func macheSuzhouZahl(aus Zahl:Int)->String?{
        guard Zahl > 0 else {
            return nil
        }
        let suzhou=SuzhouZahl(Zahl: Zahl)
        return suzhou.suzhou
    }
    
    func macheJapanischeBankZahl(aus Zahl:Int, einfach:Bool)->String?{
        guard Zahl > 0, Zahl < Int.max else {
            return nil
        }
        let z:[AlsJapanischeBankZahl]=[TenQuadrillion(Zahl: Zahl),
                                       OneTrillion(Zahl: Zahl),
                                       HundertMillionen(Zahl: Zahl),
                                       ZehnTausender(Zahl: Zahl),
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
    
    func macheBabylonischeZahl(aus Zahl:Int)->String?{
        return BabylonischeZahl(Zahl: Zahl).babylonisch
    }
    
    func macheAegaeischeZahl(aus Zahl:Int)->String?{
        return AegeanZahl(number: Zahl)?.aegean
    }
    
    func macheSangiZahl(aus Zahl:Int)->String?{
        guard Zahl > 0, Zahl < 100_000 else {
            return nil
        }
        
        let z:[AlsSangiZahl]=[ZehnTausender(Zahl: Zahl),
                              JapanischeTausender(Zahl: Zahl),
                              Hunderter(Zahl: Zahl),
                              Zehner(Zahl: Zahl),
                              Einer(Zahl: Zahl)
        ]
        
        let text = z.reduce("", {r, z in
            r+z.sangi
        }).trimmingPrefix(while: {$0 == " "})
        return String(text)
    }
    
    func macheHieroglyphenZahl(aus Zahl:Int)->String?{
        return HieroglyphenZahl(Zahl: Zahl)?.hieroglyph
    }
    
    
    
    func macheZahl(aus text:String)->NumericalOutput?{
        switch text {
        case _ where text.potenzielleRömischeZahl:
            if let zahl = self.macheZahl(römisch: text){
                return NumericalOutput(value: zahl, locale: .roman)
            }
        case _ where text.potenzielleJapanischeZahl:
            if let zahl=self.macheZahl(japanisch: text){
                return NumericalOutput(value: zahl, locale: .japanese)
            }
        case _ where text.potenzielleSuzhouZahl:
            if let zahl=SuzhouZahl(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .suzhou)
            }
        case _ where text.potenzielleHieroglypheZahl:
            if let zahl=HieroglyphenZahl(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .hieroglyph)
            }
        case _ where text.potenziellAegaeischeZahl:
            if let zahl=AegeanZahl(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .aegean)
            }
        case _ where text.potentiellePhoenizischeZahl:
            if let zahl=PhoenizianFormatter(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .phoenician)
            }
        default:
            return nil
        }
        return nil
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
        let trillion=OneTrillion(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: trillion.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        
        if restZahl.count > 0{
            return nil
        }
        
        
        return trillion.arabisch + hundertMillionen.arabisch + zehnTausender.arabisch + tausender.arabisch + hunderter.arabisch + zehner.arabisch + einser.arabisch
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
