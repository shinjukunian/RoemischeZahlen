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
        case .babylonian, .aegean, .sangi, .hieroglyph, .suzhou, .phoenician, .kharosthi, .brahmi_traditional, .brahmi_positional, .glagolitic:
            outputUtterances = [AVSpeechUtterance]()
        }
        return outputUtterances
    }
    
}


public extension Output{
    var url:URL?{
        let tableName = "URLs.strings"
        switch self {
        case .römisch:
            let string=NSLocalizedString("Roman", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Roman_numerals", comment: "")
            return URL(string: string)
        case .japanisch:
            let string=NSLocalizedString("Japanese", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Japanese_numerals", comment: "")
            return URL(string: string)
        case .arabisch:
            let string=NSLocalizedString("Arabic", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Arabic_numerals", comment: "")
            return URL(string: string)
        case .japanisch_bank:
            let string=NSLocalizedString("Japanese", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Japanese_numerals", comment: "")
            return URL(string: string)
        case .babylonian:
            let string=NSLocalizedString("Babylonian", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Babylonian_cuneiform_numerals", comment: "")
            return URL(string: string)
        case .aegean:
            let string=NSLocalizedString("Aegean", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Aegean_numerals", comment: "")
            return URL(string: string)
        case .sangi:
            let string=NSLocalizedString("Sangi", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Counting_rods", comment: "")
            return URL(string: string)
        case .hieroglyph:
            let string=NSLocalizedString("Hieroglyph", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Egyptian_numerals", comment: "")
            return URL(string: string)
        case .suzhou:
            let string=NSLocalizedString("Suzhou", tableName: tableName, bundle: .module, value:"https://en.wikipedia.org/wiki/Suzhou_numerals", comment: "")
            return URL(string: string)
        case .phoenician:
            let string=NSLocalizedString("Phoenician", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Phoenician_alphabet#Numerals", comment: "")
            return URL(string: string)
        case .kharosthi:
            let string=NSLocalizedString("Kharosthi", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Kharosthi#Numerals", comment: "")
            return URL(string: string)
        case .brahmi_positional, .brahmi_traditional:
            let string=NSLocalizedString("Brahmi", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Brahmi_numerals", comment: "")
            return URL(string: string)
        case .glagolitic:
            let string=NSLocalizedString("Glagolitic", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Glagolitic_numerals", comment: "")
            return URL(string: string)
        case .numeric(let base):
            switch base{
            case 2:
                let string=NSLocalizedString("Binary", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Binary_number", comment: "")
                return URL(string: string)
            case 8:
                let string=NSLocalizedString("Octal", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Octal", comment: "")
                return URL(string: string)
            case 16:
                let string=NSLocalizedString("Octal", tableName: "URLs", bundle: .module, value: "https://en.wikipedia.org/wiki/Hexadecimal", comment: "")
                return URL(string: string)
            default:
                return nil
            }
        case .localized(_):
            return nil
        }
    }
}
