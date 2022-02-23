//
//  Output+Categories.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/22.
//

import Foundation
import Algorithms
import AVFoundation

public extension Output{
    static  var availableLocalizedOutputs:[Output]{
        let current=Locale.current
        return Locale.availableIdentifiers
            .filter({$0.hasPrefix("ja") == false })
            .map({Locale(identifier: $0)})
            .filter({$0.languageCode != nil || $0 != current})
            .uniqued(on: {$0.languageCode ?? ""})
            .sorted(by: {l1,l2 in
                guard let language1=current.localizedString(forLanguageCode: l1.languageCode ?? ""),
                      let language2=current.localizedString(forLanguageCode: l2.languageCode ?? "")
                else{
                    return true
                }
                return language1 < language2
                
            })
            .map({Output.localized(locale: $0)})
    }
}


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


public struct SpeechOutput{
    let format:Output
    let text:String
    
    public init(text: String, format:Output) {
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
