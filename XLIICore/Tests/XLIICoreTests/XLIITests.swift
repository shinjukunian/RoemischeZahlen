//
//  XLIITests.swift
//  XLIITests
//
//  Created by Morten Bertz on 2022/02/21.
//

import XCTest
@testable import XLIICore

class XLIICoreTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBabylonisch()throws {
        let formatter=ExotischeZahlenFormatter()
        let cases : [Int:String] = [1:"𒐕",
                                    11:"𒌋𒐕",
                                    25:"《𒐙",
                                    50:"𒐐␣",
                                    99:"𒐕 𒌍𒐝",
                                    111:"𒐕 𒐐𒐕",
                                    511:"𒐜 𒌍𒐕",
                                    2018:"𒌍𒐗 𒌍𒐜",
                                    123321:"𒌍𒐘 𒌋𒐙 《𒐕",
                                    4711:"𒐕 𒌋𒐜 𒌍𒐕",
                                    99999:"《𒐛 𒐏𒐚 𒌍𒐝",
                                    455678:"𒐖 𒐚 𒌍𒐘 𒌍𒐜",
                                    60: "𒐕 ␣",
                                    59: "𒐐𒐝",
                                    602: "𒌋␣ 𒐖",
                                    610: "𒌋␣ 𒌋␣",
                                    1234321:"𒐙 𒐏𒐖 𒐐𒐖 𒐕",
                                    9876543210:"𒌋𒐖 𒐏𒐖 𒐘 𒐏𒐘 𒌋𒐗 𒌍␣"
        ]
        
        
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheBabylonischeZahl(aus: c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text )")
        }
        
    }
    
    func testSuzhou() throws {
        //https://codegolf.stackexchange.com/questions/177517/convert-to-suzhou-numerals
        let cases : [Int:String] = [1:"〡",
                                    11:"〡一",
                                    25:"〢〥",
                                    50:"〥〇",
                                    99:"〩〩",
                                    111:"〡一〡",
                                    511:"〥〡一",
                                    2018:"〢〇〡〨",
                                    123321:"〡二〣三〢一",
                                    1234321:"〡二〣〤〣二〡",
                                    9876543210:"〩〨〧〦〥〤〣二〡〇"]
        let formatter=ExotischeZahlenFormatter()
        
        for c in cases{
            let text=formatter.macheSuzhouZahl(aus: c.key)
            XCTAssert(text == c.value)
        }
        
        for c in cases{
            let number=try XCTUnwrap(formatter.macheZahl(aus: c.value))
            XCTAssert(number.locale == .suzhou)
            XCTAssert(number.value == c.key)
            
        }
        
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<100_000_000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheSuzhouZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h))
            XCTAssert(arabic.locale == .suzhou)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
        
        let zero=0
        let h=try XCTUnwrap(formatter.macheSuzhouZahl(aus: zero))
        XCTAssert(h == "〇")
    }
    
    
    func testHieroglyphs() throws{
        let formatter=ExotischeZahlenFormatter()
        let cases = [42:"𓎉𓏻", 4242:"𓆿𓍣𓎉𓏻", 2_222_222:"𓁨𓁨𓆐𓆐𓂮𓆽𓍣𓎇𓏻"]
        for c in cases{
            let text=try XCTUnwrap(formatter.macheHieroglyphenZahl(aus: c.key))
            XCTAssert(text == c.value)
            let number=try XCTUnwrap(formatter.macheZahl(aus: text))
            XCTAssert(number.locale == .hieroglyph)
            XCTAssert(number.value == c.key)
        }
        
        for c in cases.merging([203:"𓍢𓍢𓏺𓏺𓏺", 113:"𓍢𓎆𓏺𓏺𓏺", 99:"𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓏺𓏺𓏺𓏺𓏺𓏺𓏺𓏺𓏺", 12587:"𓂭𓆼𓆼𓍢𓍢𓍢𓍢𓍢𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓏺𓏺𓏺𓏺𓏺𓏺𓏺"], uniquingKeysWith: {s1,_ in return s1}){
            let number=try XCTUnwrap(formatter.macheZahl(aus: c.value))
            XCTAssert(number.locale == .hieroglyph)
            XCTAssert(number.value == c.key)

        }
        
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<10_000_000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheHieroglyphenZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h))
            XCTAssert(arabic.locale == .hieroglyph)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    func testAegean()throws{
        let formatter=ExotischeZahlenFormatter()
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<100_000)})
        for number in numbers{
            let aegean=try XCTUnwrap(formatter.macheAegaeischeZahl(aus: number))
            XCTAssert(aegean.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: aegean))
            XCTAssert(arabic.locale == .aegean)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    func testPhoenician()throws{
        let numbers=[1:"𐤖",
                2:"𐤚",
                     3:"𐤛",
                     9:"𐤛𐤛𐤛",
                     19:"𐤗𐤛𐤛𐤛",
                     20:"𐤘",
                     30:"𐤘𐤗",
                     60:"𐤘𐤘𐤘",
                     143:"𐤙𐤘𐤘𐤛",
                     340:"𐤛𐤙𐤘𐤘",
                     900:"𐤛𐤛𐤛𐤙"
        ]
        for number in numbers{
            let p=try XCTUnwrap( PhoenizianFormatter(number: number.key) )
            XCTAssert(p.phoenician == number.value, "\(number.key) converted to \(p.phoenician), expected \(number.value)")
            let reverse=try XCTUnwrap(PhoenizianFormatter(string: p.phoenician))
            XCTAssert(reverse.arabic == number.key, "\(p.phoenician) converted to \(reverse.arabic), expected \(number.key)")
        }
        
        XCTAssertNil(PhoenizianFormatter(string: "hallo"))
        XCTAssertNil(PhoenizianFormatter(number: 1000))
        XCTAssertNotNil(PhoenizianFormatter(string: "𐤗𐤛𐤛𐤛"))
        
        let random=(0..<1000).map({_ in return Int.random(in: 1..<1_000)})
        
        for number in random{
            let p=try XCTUnwrap( PhoenizianFormatter(number: number) )
            let reverse=try XCTUnwrap(PhoenizianFormatter(string: p.phoenician))
            
            XCTAssert(reverse.arabic == number, "\(p.phoenician) converted to \(reverse.arabic), expected \(number)")
        }
        
        
    }
    
    
    func testKharosthi()throws{
        
        let cases = [1996:"𐩇𐩃𐩃𐩀𐩆𐩅𐩅𐩅𐩅𐩄𐩃𐩁",
                     500:"𐩃𐩀𐩆",
                     477:"𐩃𐩆𐩅𐩅𐩅𐩄𐩃𐩂",
                     19:"𐩄𐩃𐩃𐩀",
                     12500:"𐩄𐩁𐩇𐩃𐩀𐩆",
                     16:"𐩄𐩃𐩁",
                     85:"𐩅𐩅𐩅𐩅𐩃𐩀",
                     167_000:"𐩆𐩅𐩅𐩅𐩃𐩂𐩇",

        ]
        
        for n in cases{
            let number=n.key
            let expected=n.value
            let parser=try XCTUnwrap(KharosthiNumber(number: number))
            let k=parser.kharosthi
            XCTAssert(k == expected, "print \(number) (\(expected) converted to \(k)")
            
            let reversedParser=try XCTUnwrap(KharosthiNumber(string: expected))
            XCTAssert(reversedParser.arabic == number, "print \(expected) (\(number) converted to \(reversedParser.arabic)")
            
        }
        
        let random=(0..<10_000).map({_ in return Int.random(in: 1..<1_000_000)})
        
        for number in random{
            let parser=try XCTUnwrap(KharosthiNumber(number: number))
            let kh=parser.kharosthi
            
            let reversedParser=try XCTUnwrap(KharosthiNumber(string: kh))
            XCTAssert(reversedParser.arabic == number, "print \(kh) (\(number) converted to \(reversedParser.arabic)")
        }
        
        XCTAssertNil(KharosthiNumber(string: "469"))
        
    }
    
    
    func testKharosthiSingle()throws{
        let number=1996
        let expected="𐩇𐩃𐩃𐩀𐩆𐩅𐩅𐩅𐩅𐩄𐩃𐩁"
        let parser=try XCTUnwrap(KharosthiNumber(number: number))
        let k=parser.kharosthi
        XCTAssert(k == expected, "print \(number) (\(expected) converted to \(k)")
        let reversedParser=try XCTUnwrap(KharosthiNumber(string: expected))
        XCTAssert(reversedParser.arabic == number, "print \(expected) (\(number) converted to \(reversedParser.arabic)")
    }
    
    func testBrahmi() throws {
        let joiner=String(Unicode.Scalar.init(0x1107F)!)
        let number=5368
        let expected="𑁥"+joiner+"𑁖"+"𑁤"+joiner+"𑁔"+"𑁠𑁙"
        
        let parser=try XCTUnwrap(BrahmiNumber(number: number, positional: false))
        let k=parser.brahmi
        XCTAssert(k == expected, "\(number) (\(expected) converted to \(k)")
        let reversedParser=try XCTUnwrap(BrahmiNumber(string: expected), "\(number) (\(expected)")
        XCTAssert(reversedParser.arabic == number, "print \(expected) (\(number) converted to \(reversedParser.arabic)")
        
        let cases = [3:"𑁔",
                     15:"𑁛𑁖",
                     124:"𑁤𑁜𑁕",
                     200:"𑁤"+joiner+"𑁓",
                     102:"𑁤"+"𑁓",
                     547: "𑁤"+joiner+"𑁖"+"𑁞𑁘",
                     1200: "𑁥"+"𑁤"+joiner+"𑁓",
                     833: "𑁤"+joiner+"𑁙"+"𑁝𑁔",
                     5368: "𑁥"+joiner+"𑁖"+"𑁤"+joiner+"𑁔"+"𑁠𑁙"
        ]
        
        for c in cases{
            let number=c.key
            let expected=c.value
            let parser=try XCTUnwrap(BrahmiNumber(number: number, positional: false))
            let k=parser.brahmi
            XCTAssert(k == expected, "print \(number) (\(expected) converted to \(k)")
            let reversedParser=try XCTUnwrap(BrahmiNumber(string: expected), "conversion of \(expected) (\(number) failed")
            XCTAssert(reversedParser.arabic == number, "print \(expected) (\(number)) converted to \(reversedParser.arabic)")
        }
        
        
        let positionalCases = [15:"𑁧𑁫",
                               10:"𑁧𑁦",
                               99:"𑁯𑁯",
                               128:"𑁧𑁨𑁮"
        ]
        
        for c in positionalCases{
            let number=c.key
            let expected=c.value
            let parser=try XCTUnwrap(BrahmiNumber(number: number, positional: true))
            let k=parser.brahmi
            XCTAssert(k == expected, "print \(number) (\(expected) converted to \(k)")
            let reversedParser=try XCTUnwrap(BrahmiNumber(string: expected), "conversion of \(expected) (\(number) failed")
            XCTAssert(reversedParser.arabic == number, "print \(expected) (\(number) converted to \(reversedParser.arabic)")
        }
        
        let random=(0..<2000).map({_ in return Int.random(in: 1..<10_000)})
        
        for number in random{
            let parser=try XCTUnwrap(BrahmiNumber(number: number, positional: false))
            let kh=parser.brahmi
            
            let reversedParser=try XCTUnwrap(BrahmiNumber(string: kh), "conversion of \(expected) (\(number) failed")
            XCTAssert(reversedParser.arabic == number, "print \(kh) (\(number) converted to \(reversedParser.arabic)")
        }
        
        XCTAssertNil(BrahmiNumber(string: "469"))
        
        let random2=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000)})
        
        for number in random2{
            let parser=try XCTUnwrap(BrahmiNumber(number: number, positional: true))
            let kh=parser.brahmi
            
            let reversedParser=try XCTUnwrap(BrahmiNumber(string: kh), "conversion of \(expected) (\(number) failed")
            XCTAssert(reversedParser.arabic == number, "print \(kh) (\(number) converted to \(reversedParser.arabic)")
        }
    }
    
    
    func testGeez() throws {
        let number=9900015427
        let expectation="፺፱፼፩፼፶፬፻፳፯"
        let parser=try XCTUnwrap(GeezNumber(number: number))
        XCTAssert(expectation == parser.geez, "\(parser.geez) doesnt match expectation \(expectation) (\(number)")
        
        let cases=[123:"፻፳፫",
                   99:"፺፱",
                   8976:"፹፱፻፸፮",
                   475:"፬፻፸፭",
                   83692:"፰፼፴፮፻፺፪",
                   253775:"፳፭፼፴፯፻፸፭",
                   86880087:"፹፮፻፹፰፼፹፯",
                   13:"፲፫",
                   83692788097:"፰፻፴፮፼፺፪፻፸፰፼፹፻፺፯",
                   1234567890123:"፼፳፫፻፵፭፼፷፯፻፹፱፼፻፳፫",
                   402589148:"፬፼፪፻፶፰፼፺፩፻፵፰",
                   923018624:"፱፼፳፫፻፩፼፹፮፻፳፬"
                   
        ]
        
        for c in cases{
            let number=c.key
            let expectation=c.value
            let parser=try XCTUnwrap(GeezNumber(number: number))
            XCTAssert(expectation == parser.geez, "\(parser.geez) doesnt match expectation \(expectation) (\(number)")
        }
        
    }
    
    func testGeez_reverse()throws{
        let number="፱፼፳፫፻፩፼፹፮፻፳፬ "
        let expectation=923018624
        
        let parser=try XCTUnwrap(GeezNumber(string: number))
        XCTAssert(expectation == parser.arabic, "\(parser.arabic) doesnt match expectation \(expectation) (\(number)")
        
        let cases = [12_000:"፼፳፻",
                     137:"፻፴፯",
                     9999:"፺፱፻፺፱",
                     123:"፻፳፫",
                     99:"፺፱",
                     8976:"፹፱፻፸፮",
                     475:"፬፻፸፭",
                     83692:"፰፼፴፮፻፺፪",
                     253775:"፳፭፼፴፯፻፸፭",
                     86880087:"፹፮፻፹፰፼፹፯",
                     13:"፲፫",
                     83692788097:"፰፻፴፮፼፺፪፻፸፰፼፹፻፺፯",
                     1234567890123:"፼፳፫፻፵፭፼፷፯፻፹፱፼፻፳፫",
                     923018624:"፱፼፳፫፻፩፼፹፮፻፳፬"
        ]
        
        for c in cases{
            let number=c.value
            let expectation=c.key
            
            let parser=try XCTUnwrap(GeezNumber(string: number))
            XCTAssert(expectation == parser.arabic, "\(parser.arabic) doesnt match expectation \(expectation) (\(number)")
        }
        
        let random=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        
        for number in random{
            let parser=try XCTUnwrap(GeezNumber(number: number))
            
            let reversedParser=try XCTUnwrap(GeezNumber(string: parser.geez), "conversion of \(parser.geez) (\(number) failed")
            XCTAssert(reversedParser.arabic == number, "print \(parser.geez) (expected \(number)) converted to \(reversedParser.arabic)")
        }
        
    }
    
    
    func testSangi()throws{
        let cases = [
            231:"𝍡𝍫𝍠",
            5089:"𝍭〇𝍰𝍨",
            407: "𝍣〇𝍦",
            6720: "𝍮𝍦𝍪〇"
        ]
        
        XCTAssert("𝍮𝍦𝍪〇".potentielleSangiZahl == true)
        
        let formatter=ExotischeZahlenFormatter()
        for c in cases{
            let number=try XCTUnwrap(formatter.macheSangiZahl(aus: c.key))
//            number.unicodeScalars.forEach({print(String(Int($0.value), radix: 16))})
            XCTAssert(number == c.value, "conversion failed for \(c.key): \rxpected \(c.value),\rresult: \(number)")
            let reverse=try XCTUnwrap(formatter.macheZahl(aus:number), "backconversion failed \(c.value)")
            XCTAssert(reverse.locale == .sangi)
            XCTAssert(reverse.value == c.key)
        }
        
        let random=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        
        for number in random{
            let converted=try XCTUnwrap(formatter.macheSangiZahl(aus: number))
            
            let reversedParser=try XCTUnwrap(formatter.macheZahl(aus: converted), "conversion of \(converted) (\(number) failed")
            XCTAssert(reversedParser.locale == .sangi)
            XCTAssert(reversedParser.value == number, "print \(converted) (expected \(number)) converted to \(reversedParser.value)")
        }
    }
    
    
    func testSundanese()throws{
        let cases=[999:"|᮹᮹᮹|",
                   7880:"|᮷᮸᮸᮰|",
                   50000:"|᮵᮰᮰᮰᮰|",
                   6486417:"|᮶᮴᮸᮶᮴᮱᮷|",
                   29:"|᮲᮹|",
                   725160:"|᮷᮲᮵᮱᮶᮰|"
        ]
        
        for c in cases{
            let parsed=SundaneseNumber(number: c.key)
            XCTAssert(parsed.sundanese == c.value, "\(parsed.sundanese) doesnt match expected \(c.value) (\(c.key))")
            let reversed=try XCTUnwrap(SundaneseNumber(string: c.value))
            XCTAssert(reversed.arabic == c.key)
            XCTAssert(parsed.sundanese.potentielleSundaneseZahl)
        }
        
        let random=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        for n in random{
            let parsed=SundaneseNumber(number: n)
            let reversed=try XCTUnwrap(SundaneseNumber(string: parsed.sundanese))
            XCTAssert(reversed.arabic == n)
        }
    }
    
    func testTibetan()throws{
        let cases=[90:"༩༠",
                   10000:"༡༠༠༠༠",
                   60:"༦༠",
                   17:"༡༧",
                   12:"༡༢",
                   5:"༥"
        ]
        
        let formatter=ExotischeZahlenFormatter()
        
        for c in cases{
            let parsed=try XCTUnwrap(formatter.macheTibetanischeZahl(aus: c.key))
            XCTAssert(parsed == c.value, "\(parsed) doesnt match expected \(c.value) (\(c.key))")
            let reversed=try XCTUnwrap(formatter.macheZahl(aus:c.value))
            XCTAssert(reversed.value == c.key)
            XCTAssert(reversed.locale == .tibetan)
        }
        
        let random=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        for n in random{
            let parsed=try XCTUnwrap(formatter.macheTibetanischeZahl(aus: n))
            let reversed=try XCTUnwrap(formatter.macheZahl(aus:parsed))
            XCTAssert(reversed.value == n)
            XCTAssert(reversed.locale == .tibetan)
        }
    }
    
    func testMongolian()throws{
        let cases=[90:"᠙᠐",
                   5:"᠕"
        ]
        
        let formatter=ExotischeZahlenFormatter()
        
        for c in cases{
            let parsed=try XCTUnwrap(formatter.macheMongolischeZahl(aus: c.key))
            XCTAssert(parsed == c.value, "\(parsed) doesnt match expected \(c.value) (\(c.key))")
            let reversed=try XCTUnwrap(formatter.macheZahl(aus:c.value))
            XCTAssert(reversed.value == c.key)
            XCTAssert(reversed.locale == .mongolian)
        }
        
        let random=(0..<20000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        for n in random{
            let parsed=try XCTUnwrap(formatter.macheMongolischeZahl(aus: n))
            let reversed=try XCTUnwrap(formatter.macheZahl(aus:parsed))
            XCTAssert(reversed.value == n)
            XCTAssert(reversed.locale == .mongolian)
        }
    }
    
    
}

