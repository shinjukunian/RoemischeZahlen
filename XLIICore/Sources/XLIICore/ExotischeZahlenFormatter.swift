//
//  RoemischeZahl.swift
//  RoemischeZahl
//
//  Created by Miho on 2021/04/29.
//

import Foundation
import AVFoundation

public class ExotischeZahlenFormatter{
    
    public struct NumericalOutput: Equatable{
        
        public enum InputLocale: Equatable{
            case roman
            case japanese
            case suzhou
            case hieroglyph
            case aegean
            case phoenician
            case kharosthi
            case brahmi(positional:Bool)
        }
        
        public let value:Int
        public let locale:InputLocale
    }
    
    lazy var synthesizer:AVSpeechSynthesizer=AVSpeechSynthesizer()
    
    public init(){}
    
    public func macheRömischeZahl(aus Zahl:Int)->String?{
        
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
    
    public func macheJapanischeZahl(aus Zahl:Int)->String?{
        
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
    
    public func macheKharosthiZahl(aus Zahl:Int)->String?{
        guard (1..<1_000_000).contains(Zahl) else{
            return nil
        }
        return KharosthiNumber(number: Zahl)?.kharosthi
    }
    
    public func macheSuzhouZahl(aus Zahl:Int)->String?{
        guard Zahl >= 0 else {
            return nil
        }
        let suzhou=SuzhouZahl(Zahl: Zahl)
        return suzhou.suzhou
    }
    
    public func macheJapanischeBankZahl(aus Zahl:Int, einfach:Bool)->String?{
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
    
    public func macheBabylonischeZahl(aus Zahl:Int)->String?{
        return BabylonischeZahl(Zahl: Zahl).babylonisch
    }
    
    public func machePhoenizischeZahl(aus Zahl:Int)->String?{
        return PhoenizianFormatter(number: Zahl)?.phoenician
    }
    
    public func macheAegaeischeZahl(aus Zahl:Int)->String?{
        return AegeanZahl(number: Zahl)?.aegean
    }
    
    public func macheBrahmiZahl(aus Zahl:Int, positional:Bool)-> String?{
        return BrahmiNumber(number: Zahl, positional: positional)?.brahmi
    }
    
    public func macheSangiZahl(aus Zahl:Int)->String?{
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
    
    public func macheHieroglyphenZahl(aus Zahl:Int)->String?{
        return HieroglyphenZahl(Zahl: Zahl)?.hieroglyph
    }
    
    
    
    public func macheZahl(aus text:String)->NumericalOutput?{
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
        case _ where text.potentielleKharosthiZahl:
            if let zahl=KharosthiNumber(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .kharosthi)
            }
        case _ where text.potentielleBrahmiZahl:
            if let zahl=BrahmiNumber(string: text){
                return NumericalOutput(value: zahl.arabic, locale: .brahmi(positional: zahl.positional))
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
        let tenQuadrillion=TenQuadrillion(japanischeZahl: restZahl)
        restZahl=restZahl.replacingOccurrences(of: tenQuadrillion.japanisch, with: "", options: [.backwards, .caseInsensitive, .anchored, .widthInsensitive], range: nil)
        
        if restZahl.count > 0{
            return nil
        }
        
        
        return tenQuadrillion.arabisch + trillion.arabisch + hundertMillionen.arabisch + zehnTausender.arabisch + tausender.arabisch + hunderter.arabisch + zehner.arabisch + einser.arabisch
    }
    
    
    func utterance(input:SpeechOutput, output:SpeechOutput)->[AVSpeechUtterance]{
        
        let textZumSprechen=NSLocalizedString("is:", comment: "utterance string")
        let u2 = AVSpeechUtterance(string: String(textZumSprechen))
        u2.voice=Output.arabisch.voice
        u2.rate=AVSpeechUtteranceDefaultSpeechRate
        u2.postUtteranceDelay=0.1
        
        return input.utterances + [u2] + output.utterances
    }
    
    public func speak(input:SpeechOutput, output:SpeechOutput){
        self.synthesizer.stopSpeaking(at: .immediate)
        
        self.utterance(input: input, output: output).forEach({u in
            self.synthesizer.speak(u)
        })
    }
    
}
